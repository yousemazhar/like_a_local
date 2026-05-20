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

const MODEL_CHAIN = [
  "gemini-flash-latest",
  "gemini-2.5-flash",
  "gemini-2.0-flash",
  "gemini-2.0-flash-lite",
  "gemini-1.5-flash-8b",
];
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
    const candidates: PlaceLite[] = shuffle(
      placeSnaps
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
      })
    );

    if (candidates.length === 0) {
      throw new HttpsError("failed-precondition", "No candidate places found.");
    }

    const apiKey = GEMINI_API_KEY.value();
    if (!apiKey) {
      logger.error("GEMINI_API_KEY secret is empty");
      throw new HttpsError("unavailable", "AI service not configured.");
    }

    const randomSeed = Math.random().toString(36).slice(2, 10);
    const prompt = buildPrompt(prefs, candidates, randomSeed);
    logger.info("Gemini top-pick prompt", {
      uid,
      models: MODEL_CHAIN,
      randomSeed,
      prompt,
    });

    const genAI = new GoogleGenerativeAI(apiKey);
    let lastErr: unknown;
    for (const modelName of MODEL_CHAIN) {
      try {
        const model = genAI.getGenerativeModel({
          model: modelName,
          generationConfig: {
            responseMimeType: "application/json",
            temperature: 0.9,
            topP: 0.95,
          },
        });

        const text = await generateWithRetry(model, prompt, uid, modelName);
        const parsed = parseGeminiResponse(text);

        const valid = candidates.find((c) => c.id === parsed.placeId);
        const picked = valid ?? candidates[0];
        if (!valid) {
          logger.warn("Gemini returned unknown placeId", {
            uid,
            model: modelName,
            placeId: parsed.placeId,
          });
        }
        logger.info("Gemini pick succeeded", { uid, model: modelName });
        return { placeId: picked.id, reason: parsed.reason, fallback: false };
      } catch (err) {
        lastErr = err;
        const message = err instanceof Error ? err.message : String(err);
        if (isQuotaOrBillingError(err)) {
          logger.warn("Gemini model exhausted (quota/billing), trying next", {
            uid,
            model: modelName,
            cause: message,
          });
          continue;
        }
        logger.warn("Gemini model failed, trying next", {
          uid,
          model: modelName,
          cause: message,
        });
        continue;
      }
    }

    const message = lastErr instanceof Error ? lastErr.message : String(lastErr);
    logger.warn("All Gemini models failed — using heuristic fallback", {
      uid,
      models: MODEL_CHAIN,
      cause: message,
    });
    const fallback = buildHeuristicPick(candidates, prefs);
    return { placeId: fallback.placeId, reason: fallback.reason, fallback: true };
  }
);

interface GenModel {
  generateContent(prompt: string): Promise<{ response: { text(): string } }>;
}

async function generateWithRetry(
  model: GenModel,
  prompt: string,
  uid: string,
  modelName: string
): Promise<string> {
  const backoffsMs = [0, 400, 900];
  let lastErr: unknown;
  for (let attempt = 0; attempt < backoffsMs.length; attempt++) {
    if (backoffsMs[attempt] > 0) {
      await new Promise((r) => setTimeout(r, backoffsMs[attempt]));
    }
    try {
      const result = await model.generateContent(prompt);
      return result.response.text();
    } catch (err) {
      lastErr = err;
      if (isQuotaOrBillingError(err) || !isTransientGeminiError(err)) {
        // Don't waste retries on per-model quota or auth errors —
        // the outer model-chain loop will try the next model.
        throw err;
      }
      logger.warn("Gemini transient error, retrying", {
        uid,
        model: modelName,
        attempt: attempt + 1,
        err: err instanceof Error ? err.message : String(err),
      });
    }
  }
  throw lastErr;
}

function isQuotaOrBillingError(err: unknown): boolean {
  const msg = (err instanceof Error ? err.message : String(err)).toLowerCase();
  if (!msg.includes("429")) return false;
  return (
    msg.includes("quota") ||
    msg.includes("rate") ||
    msg.includes("prepayment") ||
    msg.includes("credit") ||
    msg.includes("billing") ||
    msg.includes("exceeded") ||
    msg.includes("resource_exhausted")
  );
}

function isTransientGeminiError(err: unknown): boolean {
  const msg = (err instanceof Error ? err.message : String(err)).toLowerCase();
  return (
    msg.includes("503") ||
    msg.includes("502") ||
    msg.includes("500") ||
    msg.includes("429") ||
    msg.includes("unavailable") ||
    msg.includes("overload") ||
    msg.includes("high demand") ||
    msg.includes("deadline") ||
    msg.includes("timeout") ||
    msg.includes("fetch failed") ||
    msg.includes("network") ||
    msg.includes("econn")
  );
}

function buildHeuristicPick(
  candidates: PlaceLite[],
  prefs: { placeTypes?: string[]; moods?: string[]; budget?: string | null }
): { placeId: string; reason: string } {
  const wantedTypes = new Set((prefs.placeTypes ?? []).map((s) => s.toLowerCase()));
  const wantedMoods = new Set((prefs.moods ?? []).map((s) => s.toLowerCase()));

  const scored = candidates.map((c) => {
    let score = 0;
    if (wantedTypes.has((c.category ?? "").toLowerCase())) score += 30;
    score += (c.moods ?? []).filter((m) => wantedMoods.has(m.toLowerCase())).length * 15;
    score += Math.min(c.ratingAvg ?? 0, 5) * 4;
    return { c, score };
  });
  scored.sort((a, b) => b.score - a.score);
  const top = scored[0]?.c ?? candidates[0];

  const matchedMood = (top.moods ?? []).find((m) =>
    wantedMoods.has(m.toLowerCase())
  );
  const categoryMatches = wantedTypes.has((top.category ?? "").toLowerCase());

  const parts: string[] = [];
  if (top.ratingAvg && top.ratingAvg >= 4.5) {
    parts.push(`Highly rated`);
  } else if (top.ratingAvg && top.ratingAvg >= 4) {
    parts.push(`Well-loved`);
  } else {
    parts.push(`A solid pick`);
  }
  if (top.category) {
    parts.push(top.category.toLowerCase());
  }
  if (top.neighborhood) {
    parts.push(`in ${top.neighborhood}`);
  }
  let reason = parts.join(" ") + ".";
  if (categoryMatches && matchedMood) {
    reason += ` Matches your interest in ${matchedMood} ${top.category.toLowerCase()}.`;
  } else if (categoryMatches) {
    reason += ` Matches your interest in ${top.category.toLowerCase()}.`;
  } else if (matchedMood) {
    reason += ` Fits your ${matchedMood} vibe.`;
  }
  return { placeId: top.id, reason };
}

function buildPrompt(
  prefs: { placeTypes?: string[]; moods?: string[]; budget?: string | null },
  candidates: PlaceLite[],
  randomSeed: string
): string {
  const prefsJson = JSON.stringify({
    placeTypes: prefs.placeTypes ?? [],
    atmosphere: prefs.moods ?? [],
    budget: prefs.budget ?? "any",
  });
  const candJson = JSON.stringify(candidates);

  return [
    "You are a local-travel assistant. Pick ONE place from CANDIDATES that fits the user's PREFERENCES.",
    "Do not always choose the top-ranked or first candidate. Use the RANDOM_SEED to add variety between valid matches.",
    "If several candidates are reasonable fits, rotate among them and prefer a different good option from the obvious first choice.",
    "Respond ONLY with strict JSON of the shape: {\"placeId\": string, \"reason\": string}.",
    "The `reason` must be one short sentence (max 30 words) explaining why this place fits the user. Address the user directly (\"you\"). Do not invent details not in the candidate data.",
    "",
    `RANDOM_SEED: ${randomSeed}`,
    `PREFERENCES: ${prefsJson}`,
    `CANDIDATES: ${candJson}`,
  ].join("\n");
}

function shuffle<T>(items: T[]): T[] {
  const copy = [...items];
  for (let i = copy.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [copy[i], copy[j]] = [copy[j], copy[i]];
  }
  return copy;
}

function parseGeminiResponse(text: string): { placeId: string; reason: string } {
  const cleaned = text.trim().replace(/^```json\s*/i, "").replace(/```$/, "").trim();
  const obj = JSON.parse(cleaned) as { placeId?: string; reason?: string };
  if (!obj.placeId || !obj.reason) {
    throw new Error("Malformed Gemini response");
  }
  return { placeId: obj.placeId, reason: obj.reason };
}
