import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/domain/auth_providers.dart';
import '../../place/domain/place.dart';
import '../../place/domain/place_providers.dart';
import '../data/ranking_repository.dart';

part 'ranking_providers.g.dart';

@Riverpod(keepAlive: true)
RankingRepository rankingRepository(RankingRepositoryRef ref) =>
    RankingRepository(FirebaseFirestore.instance, FirebaseFunctions.instance);

@riverpod
Stream<List<String>> rankedPlaceIds(RankedPlaceIdsRef ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return const Stream.empty();
  return ref.watch(rankingRepositoryProvider).rankedPlaceIds(user.uid);
}

/// Returns AI-ranked discover feed when available, otherwise falls back to
/// the recency-sorted [discoverFeedProvider] list.
@riverpod
Future<List<Place>> rankedDiscoverFeed(RankedDiscoverFeedRef ref) async {
  final ids = await ref.watch(rankedPlaceIdsProvider.future);
  if (ids.isEmpty) {
    return ref.watch(discoverFeedProvider.future);
  }
  final repo = ref.watch(placeRepositoryProvider);
  final places = await Future.wait(
    ids.take(20).map((id) => repo.placeById(id).first),
  );
  return places.whereType<Place>().toList();
}

@riverpod
class RefreshRanking extends _$RefreshRanking {
  @override
  void build() {}

  Future<void> refresh() => ref.read(rankingRepositoryProvider).refresh();
}
