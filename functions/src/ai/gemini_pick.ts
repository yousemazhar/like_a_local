import { getFirestore } from "firebase-admin/firestore";
import { onCall, HttpsError } from "firebase-functions/v2/https";
import { defineSecret } from "firebase-functions/params";
import { logger } from "firebase-functions";
import { GoogleGenerativeAI } from "@google/generative-ai";

const GEMINI_API_KEY = defineSecret("GEMINI_API_KEY");

interface PlaceLite {
  id: string;
  title: string;
  category: string;
  moods: string[];
  priceLevel: string;
  neighborhood: string;
  ratingAvg: number;
  description: string;
}

const MODEL_NAME = "gemini-1.5-flash";
const MAX_CANDIDATES = 10;

/**
 * Premium-only: asks Gemini to pick ONE place from the top-ranked candidates
 * and return a short, personal reason. The mobile client calls this AFTER
 * `rankPlacesForUser` has populated `rankings/{uid}`.
 *
 * Returns `{ placeId, reason }`. Throws `unavailable` on any Gemini error so
 * the client falls back to showing the ranked list without the AI pick card.
 */
export const geminiTopPick = onCall(
  { secrets: [GEMINI_API_KEY], region: "us-central1", enforceAppCheck: false },
  async (request) => {
    const uid = request.auth?.uid;
    if (!uid) {
      throw new HttpsError("unauthenticated", "Sign in required.");
    }

    const db = getFirestore();
    const userSnap = await db.collection("users").doc(uid).get();
    const userData = userSnap.data() ?? {};
    if (userData.premium !== true) {
      throw new HttpsError("permission-denied", "Premium feature.");
    }

    const prefs = (userData.preferences ?? {}) as {
      placeTypes?: string[];
      moods?: string[];
      budget?: string | null;
    };

    const rankingSnap = await db.collection("rankings").doc(uid).get();
    const rankingData = rankingSnap.data();
    const placeIds = ((rankingData?.placeIds as string[] | undefined) ?? []).slice(
      0,
      MAX_CANDIDATES
    );
    if (placeIds.length === 0) {
      throw new HttpsError("failed-precondition", "No ranked places yet.");
    }

    const placeSnaps = await Promise.all(
      placeIds.map((id) => db.collection("places").doc(id).get())
    );
    const candidates: PlaceLite[] = placeSnaps
      .filter((s) => s.exists)
      .map((s) => {
        const d = s.data() ?? {};
        return {
          id: s.id,
          title: (d.title as string) ?? "",
          category: (d.category as string) ?? "",
          moods: (d.moods as string[]) ?? [],
          priceLevel: (d.priceLevel as string) ?? "",
          neighborhood: (d.neighborhood as string) ?? "",
          ratingAvg: (d.ratingAvg as number) ?? 0,
          description: ((d.description as string) ?? "").slice(0, 280),
        };
      });

    if (candidates.length === 0) {
      throw new HttpsError("failed-precondition", "No candidate places found.");
    }

    const apiKey = GEMINI_API_KEY.value();
    if (!apiKey) {
      logger.error("GEMINI_API_KEY secret is empty");
      throw new HttpsError("unavailable", "AI service not configured.");
    }

    const prompt = buildPrompt(prefs, candidates);

    try {
      const genAI = new GoogleGenerativeAI(apiKey);
      const model = genAI.getGenerativeModel({
        model: MODEL_NAME,
        generationConfig: {
          responseMimeType: "application/json",
          temperature: 0.4,
        },
      });
      const result = await model.generateContent(prompt);
      const text = result.response.text();
      const parsed = parseGeminiResponse(text);

      const valid = candidates.find((c) => c.id === parsed.placeId);
      if (!valid) {
        logger.warn("Gemini returned unknown placeId", {
          uid,
          placeId: parsed.placeId,
        });
        return { placeId: candidates[0].id, reason: parsed.reason };
      }

      return { placeId: valid.id, reason: parsed.reason };
    } catch (err) {
      logger.error("Gemini pick failed", { uid, err: (err as Error).message });
      throw new HttpsError("unavailable", "AI service is currently unavailable.");
    }
  }
);

function buildPrompt(
  prefs: { placeTypes?: string[]; moods?: string[]; budget?: string | null },
  candidates: PlaceLite[]
): string {
  const prefsJson = JSON.stringify({
    placeTypes: prefs.placeTypes ?? [],
    atmosphere: prefs.moods ?? [],
    budget: prefs.budget ?? "any",
  });
  const candJson = JSON.stringify(candidates);

  return [
    "You are a local-travel assistant. Pick ONE place from CANDIDATES that best matches the user's PREFERENCES.",
    "Respond ONLY with strict JSON of the shape: {\"placeId\": string, \"reason\": string}.",
    "The `reason` must be one short sentence (max 30 words) explaining why this place fits the user. Address the user directly (\"you\"). Do not invent details not in the candidate data.",
    "",
    `PREFERENCES: ${prefsJson}`,
    `CANDIDATES: ${candJson}`,
  ].join("\n");
}

function parseGeminiResponse(text: string): { placeId: string; reason: string } {
  const cleaned = text.trim().replace(/^```json\s*/i, "").replace(/```$/, "").trim();
  const obj = JSON.parse(cleaned) as { placeId?: string; reason?: string };
  if (!obj.placeId || !obj.reason) {
    throw new Error("Malformed Gemini response");
  }
  return { placeId: obj.placeId, reason: obj.reason };
}
