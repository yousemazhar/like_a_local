import { getFirestore, Timestamp } from "firebase-admin/firestore";
import { onCall, HttpsError } from "firebase-functions/v2/https";
import { logger } from "firebase-functions";

interface PlaceCandidate {
  id: string;
  category: string;
  moods: string[];
  ratingAvg: number;
  ratingCount: number;
  saveCount: number;
  neighborhood: string;
  city: string;
}

interface RankedPlace {
  placeId: string;
  score: number;
  reason: string;
}

/**
 * Score-only ranking (heuristic). Vertex AI Gemini integration can replace
 * the scoring step with a structured-output call; the wrapper, the cache
 * write, and the client contract stay the same.
 */
function heuristicRank(
  candidates: PlaceCandidate[],
  prefs: { placeTypes: string[]; moods: string[] }
): RankedPlace[] {
  const wantedTypes = new Set((prefs.placeTypes ?? []).map((s) => s.toLowerCase()));
  const wantedMoods = new Set((prefs.moods ?? []).map((s) => s.toLowerCase()));

  return candidates
    .map((p) => {
      let score = 0;
      const reasons: string[] = [];

      if (wantedTypes.has((p.category ?? "").toLowerCase())) {
        score += 30;
        reasons.push("matches your category preference");
      }

      const moodOverlap = (p.moods ?? []).filter((m) =>
        wantedMoods.has(m.toLowerCase())
      ).length;
      if (moodOverlap > 0) {
        score += moodOverlap * 15;
        reasons.push(`${moodOverlap} mood${moodOverlap > 1 ? "s" : ""} match`);
      }

      score += Math.min(p.ratingAvg, 5) * 4;
      score += Math.min(p.saveCount, 100) * 0.2;

      if (p.ratingCount >= 5) score += 5;

      return {
        placeId: p.id,
        score: Math.round(score * 100) / 100,
        reason: reasons.length > 0 ? reasons.join(" · ") : "popular pick",
      };
    })
    .sort((a, b) => b.score - a.score)
    .slice(0, 50);
}

export const rankPlacesForUser = onCall(
  { region: "us-central1", enforceAppCheck: false },
  async (request) => {
    const uid = request.auth?.uid;
    if (!uid) {
      throw new HttpsError("unauthenticated", "Sign in required.");
    }

    const db = getFirestore();
    const userSnap = await db.collection("users").doc(uid).get();
    const userData = userSnap.data() ?? {};
    const prefs = (userData.preferences ?? {}) as {
      placeTypes?: string[];
      moods?: string[];
    };

    const candidatesSnap = await db
      .collection("places")
      .where("hidden", "==", false)
      .orderBy("createdAt", "desc")
      .limit(200)
      .get();

    const candidates: PlaceCandidate[] = candidatesSnap.docs.map((d) => {
      const data = d.data();
      return {
        id: d.id,
        category: data.category ?? "",
        moods: (data.moods as string[]) ?? [],
        ratingAvg: (data.ratingAvg as number) ?? 0,
        ratingCount: (data.ratingCount as number) ?? 0,
        saveCount: (data.saveCount as number) ?? 0,
        neighborhood: (data.neighborhood as string) ?? "",
        city: (data.city as string) ?? "",
      };
    });

    const ranked = heuristicRank(candidates, {
      placeTypes: prefs.placeTypes ?? [],
      moods: prefs.moods ?? [],
    });

    const payload = {
      forTab: "discover",
      generatedAt: Timestamp.now(),
      placeIds: ranked.map((r) => r.placeId),
      scores: Object.fromEntries(ranked.map((r) => [r.placeId, r.score])),
      reasons: Object.fromEntries(ranked.map((r) => [r.placeId, r.reason])),
      stale: false,
      ttlMs: 24 * 60 * 60 * 1000,
    };

    await db.collection("rankings").doc(uid).set(payload);
    logger.info("Ranked feed for user", { uid, count: ranked.length });

    return { count: ranked.length, placeIds: payload.placeIds };
  }
);
