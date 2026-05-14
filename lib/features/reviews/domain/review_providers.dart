import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/errors/offline_exception.dart';
import '../../../core/providers/connectivity_provider.dart';
import '../../auth/domain/auth_providers.dart';
import '../data/review_repository.dart';
import 'review.dart';

part 'review_providers.g.dart';

@Riverpod(keepAlive: true)
ReviewRepository reviewRepository(ReviewRepositoryRef ref) =>
    ReviewRepository(FirebaseFirestore.instance);

@riverpod
Stream<List<Review>> placeReviews(PlaceReviewsRef ref, String placeId) =>
    ref.watch(reviewRepositoryProvider).reviewsStream(placeId);

@riverpod
Stream<Review?> myPlaceReview(MyPlaceReviewRef ref, String placeId) {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return Stream.value(null);
  return ref.watch(reviewRepositoryProvider).myReview(placeId, user.uid);
}

@riverpod
class ReviewNotifier extends _$ReviewNotifier {
  @override
  void build() {}

  void _ensureOnline() {
    if (ref.read(isOnlineProvider).valueOrNull == false) {
      throw const OfflineException();
    }
  }

  Future<void> submit({
    required String placeId,
    required int rating,
    required String text,
  }) async {
    _ensureOnline();
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) return;
    await ref
        .read(reviewRepositoryProvider)
        .upsertReview(
          placeId: placeId,
          uid: user.uid,
          displayName: user.displayName ?? 'Anonymous',
          photoUrl: user.photoUrl,
          isSuper: user.role == 'super',
          rating: rating,
          text: text,
        );
  }

  Future<void> delete(String placeId, String reviewId) {
    _ensureOnline();
    return ref.read(reviewRepositoryProvider).deleteReview(placeId, reviewId);
  }
}
