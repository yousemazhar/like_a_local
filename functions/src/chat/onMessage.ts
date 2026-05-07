import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import { getMessaging } from "firebase-admin/messaging";
import { logger } from "firebase-functions";

/**
 * Fans out a new chat message:
 *   - bumps thread's lastMessage / lastAt / unread counter
 *   - sends FCM data+notification to all other thread members with tokens
 */
export const onChatMessageCreate = onDocumentCreated(
  { document: "chats/{threadId}/messages/{messageId}", region: "us-central1" },
  async (event) => {
    const snap = event.data;
    if (!snap) return;
    const message = snap.data();
    const { threadId } = event.params;
    const senderUid = message.senderUid as string | undefined;
    const text = (message.text as string | undefined) ?? "";

    if (!senderUid) return;

    const db = getFirestore();
    const threadRef = db.collection("chats").doc(threadId);
    const threadSnap = await threadRef.get();
    const thread = threadSnap.data();
    if (!thread) return;

    const members = (thread.members as string[] | undefined) ?? [];
    const recipients = members.filter((m) => m !== senderUid);

    // Update thread doc — bump unread for each recipient.
    const update: Record<string, unknown> = {
      lastMessage: text,
      lastAt: FieldValue.serverTimestamp(),
    };
    for (const r of recipients) {
      update[`unread.${r}`] = FieldValue.increment(1);
    }
    await threadRef.set(update, { merge: true });

    // Sender display name for the notification body.
    let senderName = "New message";
    try {
      const senderSnap = await db.collection("users").doc(senderUid).get();
      senderName =
        (senderSnap.data()?.displayName as string | undefined) ?? senderName;
    } catch (_) {
      /* ignore */
    }

    // Collect FCM tokens for each recipient (respecting chatSettings.enabled).
    const tokens: string[] = [];
    for (const r of recipients) {
      const userSnap = await db.collection("users").doc(r).get();
      const data = userSnap.data();
      if (!data) continue;
      const chatEnabled = data?.chatSettings?.enabled;
      if (chatEnabled === false) continue;
      const userTokens = (data.fcmTokens as string[] | undefined) ?? [];
      tokens.push(...userTokens);
    }

    if (tokens.length === 0) {
      logger.info(`onChatMessageCreate: no tokens to notify for ${threadId}`);
      return;
    }

    try {
      await getMessaging().sendEachForMulticast({
        tokens,
        notification: {
          title: senderName,
          body: text.length > 120 ? text.slice(0, 117) + "…" : text,
        },
        data: {
          type: "chat",
          threadId,
        },
        android: { priority: "high" },
        apns: {
          headers: { "apns-priority": "10" },
          payload: { aps: { sound: "default" } },
        },
      });
      logger.info(`onChatMessageCreate: notified ${tokens.length} tokens`);
    } catch (err) {
      logger.error("FCM send failed", err);
    }
  }
);
