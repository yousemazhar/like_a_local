import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { getFirestore } from "firebase-admin/firestore";
import { logger } from "firebase-functions";

const FREE_PIN_LIMIT = 10;

/**
 * Server-side enforcement for the free-tier pin cap. If a non-premium user
 * creates a pin beyond `FREE_PIN_LIMIT`, the offending doc is deleted so the
 * client cannot bypass the in-app paywall by writing to Firestore directly.
 */
export const enforceFreePinLimit = onDocumentCreated(
  { document: "saves/{uid}/pins/{placeId}", region: "us-central1" },
  async (event) => {
    const { uid, placeId } = event.params;
    const db = getFirestore();

    const userSnap = await db.collection("users").doc(uid).get();
    const premium = (userSnap.data()?.premium as boolean | undefined) === true;
    if (premium) return;

    const pins = await db.collection("saves").doc(uid).collection("pins").get();
    if (pins.size <= FREE_PIN_LIMIT) return;

    logger.info(
      `Pin limit exceeded for uid=${uid} (count=${pins.size}). Deleting ${placeId}.`,
    );
    await db
      .collection("saves")
      .doc(uid)
      .collection("pins")
      .doc(placeId)
      .delete();
  },
);
