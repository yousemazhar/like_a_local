import {
  FieldValue,
  getFirestore,
  Timestamp,
  WriteBatch,
} from "firebase-admin/firestore";
import {
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
  try {
    const snap = await query.count().get();
    return snap.data().count;
  } catch (err) {
    logger.warn("Aggregate count failed; falling back to document count", err);
    try {
      const snap = await query.get();
      return snap.size;
    } catch (fallbackErr) {
      logger.error("Document count fallback failed", fallbackErr);
      throw fallbackErr;
    }
  }
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
    const data = place.data();
    const update: Record<string, unknown> = {
      ownerIsSuper: isSuper,
      ownerSuperScore: score,
    };
    if (data.hidden === undefined) update.hidden = false;
    if (data.ratingAvg === undefined) update.ratingAvg = 0;
    if (data.ratingCount === undefined) update.ratingCount = 0;
    if (data.saveCount === undefined) update.saveCount = 0;

    batch.set(
      place.ref,
      update,
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
    return data.ownerIsSuper !== isSuper ||
      data.ownerSuperScore !== score ||
      data.hidden === undefined ||
      data.ratingAvg === undefined ||
      data.ratingCount === undefined ||
      data.saveCount === undefined;
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

export const recalculateAllSuperUserRanks = onCall(
  { region: "us-central1", enforceAppCheck: false, timeoutSeconds: 540 },
  async (request) => {
    if (!request.auth?.uid) {
      throw new HttpsError("unauthenticated", "Sign in required.");
    }

    const db = getFirestore();
    const usersSnap = await db.collection("users").get();
    const results = [];

    for (const user of usersSnap.docs) {
      const result = await recalculateSuperUserForUid(user.id);
      results.push({
        uid: user.id,
        score: result.score,
        isSuper: result.isSuper,
      });
    }

    logger.info("Recalculated all super-user ranks", {
      requestedBy: request.auth.uid,
      userCount: results.length,
    });

    return {
      userCount: results.length,
      superUserCount: results.filter((result) => result.isSuper).length,
      results,
    };
  }
);

export const onPlaceWrittenRecalculateSuperUser = onDocumentWritten(
  { document: "places/{placeId}", region: "us-central1" },
  async (event) => {
    const beforeOwnerUid = event.data?.before.data()?.ownerUid as
      | string
      | undefined;
    const afterOwnerUid = event.data?.after.data()?.ownerUid as
      | string
      | undefined;
    const ownerUids = new Set(
      [beforeOwnerUid, afterOwnerUid].filter((uid): uid is string => Boolean(uid))
    );

    if (event.data?.before.exists && event.data?.after.exists) {
      const ownerChanged = beforeOwnerUid !== afterOwnerUid;
      if (!ownerChanged) return;
    }

    await Promise.all(
      [...ownerUids].map((ownerUid) => recalculateSuperUserForUid(ownerUid))
    );
  }
);

export const onChatMessageDeleteRecalculateSuperUser = onDocumentDeleted(
  { document: "chats/{threadId}/messages/{messageId}", region: "us-central1" },
  async (event) => {
    const senderUid = event.data?.data()?.senderUid as string | undefined;
    if (!senderUid) return;
    await recalculateSuperUserForUid(senderUid);
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
