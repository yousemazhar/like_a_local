const test = require("node:test");
const assert = require("node:assert/strict");

const {
  calculateSuperUserScore,
  isSuperUserScore,
} = require("../lib/superUsers/score");

test("calculates balanced super-user score", () => {
  const score = calculateSuperUserScore({
    placesCount: 3,
    chatCount: 10,
    reviewsCount: 2,
    averageReviewRating: 4.5,
  });

  assert.equal(score, 135);
});

test("uses 100 as the super-user threshold", () => {
  assert.equal(isSuperUserScore(99.99), false);
  assert.equal(isSuperUserScore(100), true);
});
