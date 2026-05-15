import { initializeApp } from "firebase-admin/app";
import { getFirestore } from "firebase-admin/firestore";
import { onCall, HttpsError, onRequest } from "firebase-functions/v2/https";
import { defineSecret } from "firebase-functions/params";
import { logger } from "firebase-functions";
import Stripe from "stripe";

initializeApp();

export { rankPlacesForUser } from "./ai/rank";
export { geminiTopPick } from "./ai/gemini_pick";
export { seedEgyptPlaces } from "./seed/egypt";
export { onChatMessageCreate } from "./chat/onMessage";
export { sendTestNotification } from "./notifications/test";
export {
  onPlaceCreatedRecalculateSuperUser,
  onPlaceDeletedRecalculateSuperUser,
  onReviewWrittenRecalculateSuperUser,
  recalculateSuperUserRank,
} from "./superUsers/rank";

const STRIPE_SECRET_KEY = defineSecret("STRIPE_SECRET_KEY");
const STRIPE_WEBHOOK_SECRET = defineSecret("STRIPE_WEBHOOK_SECRET");

function stripeClient(key: string): Stripe {
  return new Stripe(key, { apiVersion: "2024-06-20" as Stripe.LatestApiVersion });
}

/**
 * Creates a Stripe PaymentIntent + Ephemeral Key + Customer for the signed-in
 * user, so the client can present the Stripe PaymentSheet.
 *
 * Accepts `{ plan: 'monthly' | 'yearly' }` to charge €4.99 or €35.88.
 */
const PLAN_AMOUNTS_EUR_CENTS: Record<string, number> = {
  monthly: 499,
  yearly: 3588,
};

export const createPaymentIntent = onCall(
  { secrets: [STRIPE_SECRET_KEY], region: "us-central1", enforceAppCheck: false },
  async (request) => {
    const uid = request.auth?.uid;
    if (!uid) {
      throw new HttpsError("unauthenticated", "Sign in required.");
    }

    const plan = (request.data?.plan as string | undefined) ?? "monthly";
    const amount = PLAN_AMOUNTS_EUR_CENTS[plan] ?? PLAN_AMOUNTS_EUR_CENTS.monthly;

    const stripe = stripeClient(STRIPE_SECRET_KEY.value());
    const db = getFirestore();
    const userRef = db.collection("users").doc(uid);
    const userSnap = await userRef.get();
    const userData = userSnap.data() ?? {};

    let customerId = userData.stripeCustomerId as string | undefined;
    if (!customerId) {
      const customer = await stripe.customers.create({
        email: userData.email,
        metadata: { uid },
      });
      customerId = customer.id;
      await userRef.set({ stripeCustomerId: customerId }, { merge: true });
    }

    const ephemeralKey = await stripe.ephemeralKeys.create(
      { customer: customerId },
      { apiVersion: "2024-06-20" }
    );

    const paymentIntent = await stripe.paymentIntents.create({
      amount,
      currency: "eur",
      customer: customerId,
      automatic_payment_methods: { enabled: true },
      metadata: { uid, plan },
    });

    return {
      paymentIntentClientSecret: paymentIntent.client_secret,
      ephemeralKeySecret: ephemeralKey.secret,
      customerId,
    };
  }
);

/**
 * Stripe webhook: on payment_intent.succeeded, flip users/{uid}.premium = true.
 * Uses the raw body (onRequest exposes req.rawBody) for signature verification.
 */
export const stripeWebhook = onRequest(
  { secrets: [STRIPE_SECRET_KEY, STRIPE_WEBHOOK_SECRET], region: "us-central1", invoker: "public" },
  async (req, res) => {
    const signature = req.headers["stripe-signature"];
    if (!signature || typeof signature !== "string") {
      res.status(400).send("Missing stripe-signature header");
      return;
    }

    const stripe = stripeClient(STRIPE_SECRET_KEY.value());

    let event: Stripe.Event;
    try {
      event = stripe.webhooks.constructEvent(
        req.rawBody,
        signature,
        STRIPE_WEBHOOK_SECRET.value()
      );
    } catch (err) {
      logger.error("Webhook signature verification failed", err);
      res.status(400).send(`Webhook Error: ${(err as Error).message}`);
      return;
    }

    if (event.type === "payment_intent.succeeded") {
      const intent = event.data.object as Stripe.PaymentIntent;
      const uid = intent.metadata?.uid;
      if (uid) {
        await getFirestore().collection("users").doc(uid).set(
          {
            premium: true,
            premiumPlan: intent.metadata?.plan ?? "monthly",
            premiumUpdatedAt: new Date(),
            lastPaymentIntentId: intent.id,
          },
          { merge: true }
        );
        logger.info(`Flipped users/${uid}.premium = true (pi=${intent.id})`);
      } else {
        logger.warn("payment_intent.succeeded with no uid metadata", {
          id: intent.id,
        });
      }
    }

    res.status(200).send("ok");
  }
);
