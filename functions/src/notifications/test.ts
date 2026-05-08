import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import { getMessaging } from "firebase-admin/messaging";
import { logger } from "firebase-functions";

/**
 * Sends a test push notification to the caller's own FCM tokens and writes a
 * matching document into `notifications/{uid}/items` so the in-app inbox lights
 * up too. Used by the "Test push" button on the Profile screen.
 */
export const sendTestNotification = onCall(
  { region: "us-central1", enforceAppCheck: false },
  async (request) => {
    const uid = request.auth?.uid;
    if (!uid) throw new HttpsError("unauthenticated", "Sign in required.");

    const db = getFirestore();
    const userSnap = await db.collection("users").doc(uid).get();
    const data = userSnap.data() ?? {};
    const tokens = (data.fcmTokens as string[] | undefined) ?? [];

    const title = "LikeALocal · test push";
    const body = "If you can read this, push notifications are working.";

    await db
      .collection("notifications")
      .doc(uid)
      .collection("items")
      .add({
        type: "system",
        title,
        body,
        read: false,
        createdAt: FieldValue.serverTimestamp(),
      });

    let delivered = 0;
    if (tokens.length > 0) {
      try {
        const res = await getMessaging().sendEachForMulticast({
          tokens,
          notification: { title, body },
          data: { type: "system" },
          android: { priority: "high" },
          apns: { payload: { aps: { sound: "default" } } },
        });
        delivered = res.successCount;
        const stale: string[] = [];
        res.responses.forEach((r, i) => {
          if (
            !r.success &&
            (r.error?.code === "messaging/registration-token-not-registered" ||
              r.error?.code === "messaging/invalid-registration-token")
          ) {
            stale.push(tokens[i]);
          }
        });
        if (stale.length > 0) {
          await db
            .collection("users")
            .doc(uid)
            .update({ fcmTokens: FieldValue.arrayRemove(...stale) });
        }
      } catch (e) {
        logger.warn("sendTestNotification: FCM dispatch failed", e);
      }
    }

    return { tokens: tokens.length, delivered };
  }
);
