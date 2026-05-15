export interface SuperUserStats {
  placesCount: number;
  chatCount: number;
  reviewsCount: number;
  averageReviewRating: number;
}

export const SUPER_USER_THRESHOLD = 100;

export function calculateSuperUserScore(stats: SuperUserStats): number {
  const score =
    stats.placesCount * 20 +
    stats.chatCount * 2 +
    stats.reviewsCount * 5 +
    stats.averageReviewRating * 10;

  return Math.round(score * 100) / 100;
}

export function isSuperUserScore(score: number): boolean {
  return score >= SUPER_USER_THRESHOLD;
}
