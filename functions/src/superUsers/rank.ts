import {
  FieldValue,
  getFirestore,
  Timestamp,
  WriteBatch,
} from "firebase-admin/firestore";
import {
  onDocumentCreated,
  onDocumentDeleted,
  onDocumentWritten,
} from "firebase-functions/v2/firestore";
import { HttpsError, onCall } from "firebase-functions/v2/https";
import { logger } from "firebase-functions";

import {
  calculateSuperUserScore,
  isSuperUserScore,
  SuperUserStats,
} from "./score";

const PLACE_UPDATE_BATCH_SIZE = 450;

async function countQuery(
  query: FirebaseFirestore.Query<FirebaseFirestore.DocumentData>
): Promise<number> {
  const snap = await query.count().get();
  return snap.data().count;
}

async function commitBatch(batch: WriteBatch, writes: number): Promise<void> {
  if (writes > 0) await batch.commit();
}

async function propagateOwnerStatus(
  uid: string,
  isSuper: boolean,
  score: number
): Promise<void> {
  const db = getFirestore();
  const places = await db.collection("places").where("ownerUid", "==", uid).get();

  let batch = db.batch();
  let writes = 0;

  for (const place of places.docs) {
    batch.set(
      place.ref,
      {
        ownerIsSuper: isSuper,
        ownerSuperScore: score,
      },
      { merge: true }
    );
    writes += 1;

    if (writes >= PLACE_UPDATE_BATCH_SIZE) {
      await batch.commit();
      batch = db.batch();
      writes = 0;
    }
  }

  await commitBatch(batch, writes);
}

export async function recalculateSuperUserForUid(uid: string): Promise<{
  score: number;
  isSuper: boolean;
  stats: SuperUserStats;
}> {
  const db = getFirestore();
  const userRef = db.collection("users").doc(uid);
  const userSnap = await userRef.get();
  const previousRole = (userSnap.data()?.role as string | undefined) ?? "user";

  const placesSnap = await db
    .collection("places")
    .where("ownerUid", "==", uid)
    .get();
  const placesCount = placesSnap.size;

  let reviewsCount = 0;
  let ratingTotal = 0;
  for (const place of placesSnap.docs) {
    const reviewsSnap = await place.ref.collection("reviews").get();
    reviewsCount += reviewsSnap.size;
    for (const review of reviewsSnap.docs) {
      ratingTotal += (review.data().rating as number | undefined) ?? 0;
    }
  }

  const chatCount = await countQuery(
    db.collectionGroup("messages").where("senderUid", "==", uid)
  );
  const averageReviewRating =
    reviewsCount === 0 ? 0 : Math.round((ratingTotal / reviewsCount) * 100) / 100;

  const stats: SuperUserStats = {
    placesCount,
    chatCount,
    reviewsCount,
    averageReviewRating,
  };
  const score = calculateSuperUserScore(stats);
  const isSuper = isSuperUserScore(score);
  const role = isSuper ? "super" : "user";
  const now = Timestamp.now();

  await userRef.set(
    {
      role,
      superUserScore: score,
      superUserStats: stats,
      superUserScoreUpdatedAt: now,
      ...(isSuper && previousRole !== "super" ? { superUserBecameAt: now } : {}),
    },
    { merge: true }
  );

  if (previousRole !== role || placesSnap.docs.some((p) => {
    const data = p.data();
    return data.ownerIsSuper !== isSuper || data.ownerSuperScore !== score;
  })) {
    await propagateOwnerStatus(uid, isSuper, score);
  }

  logger.info("Recalculated super-user rank", {
    uid,
    score,
    role,
    placesCount,
    chatCount,
    reviewsCount,
    averageReviewRating,
  });

  return { score, isSuper, stats };
}

export const recalculateSuperUserRank = onCall(
  { region: "us-central1", enforceAppCheck: false },
  async (request) => {
    const uid = request.data?.uid as string | undefined;
    const targetUid = uid ?? request.auth?.uid;

    if (!targetUid) {
      throw new HttpsError("unauthenticated", "Sign in required.");
    }
    if (uid && request.auth?.uid !== uid) {
      throw new HttpsError("permission-denied", "Can only refresh your own rank.");
    }

    return recalculateSuperUserForUid(targetUid);
  }
);

export const onPlaceCreatedRecalculateSuperUser = onDocumentCreated(
  { document: "places/{placeId}", region: "us-central1" },
  async (event) => {
    const ownerUid = event.data?.data().ownerUid as string | undefined;
    if (ownerUid) await recalculateSuperUserForUid(ownerUid);
  }
);

export const onPlaceDeletedRecalculateSuperUser = onDocumentDeleted(
  { document: "places/{placeId}", region: "us-central1" },
  async (event) => {
    const ownerUid = event.data?.data().ownerUid as string | undefined;
    if (ownerUid) await recalculateSuperUserForUid(ownerUid);
  }
);

export const onReviewWrittenRecalculateSuperUser = onDocumentWritten(
  { document: "places/{placeId}/reviews/{reviewId}", region: "us-central1" },
  async (event) => {
    const db = getFirestore();
    const placeId = event.params.placeId;
    const placeSnap = await db.collection("places").doc(placeId).get();
    const ownerUid = placeSnap.data()?.ownerUid as string | undefined;
    if (!ownerUid) return;

    await recalculateSuperUserForUid(ownerUid);
    if (event.data?.after.exists || event.data?.before.exists) {
      const reviewsSnap = await db
        .collection("places")
        .doc(placeId)
        .collection("reviews")
        .get();
      const ratingTotal = reviewsSnap.docs.reduce(
        (total, doc) => total + ((doc.data().rating as number | undefined) ?? 0),
        0
      );
      await db.collection("places").doc(placeId).set(
        {
          ratingCount: reviewsSnap.size,
          ratingAvg:
            reviewsSnap.size === 0
              ? 0
              : Math.round((ratingTotal / reviewsSnap.size) * 100) / 100,
          updatedAt: FieldValue.serverTimestamp(),
        },
        { merge: true }
      );
    }
  }
);
