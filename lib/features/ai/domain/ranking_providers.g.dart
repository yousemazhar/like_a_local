// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ranking_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$rankingRepositoryHash() => r'478c4633733aedfbc61634069ce1df699827fcbc';

/// See also [rankingRepository].
@ProviderFor(rankingRepository)
final rankingRepositoryProvider = Provider<RankingRepository>.internal(
  rankingRepository,
  name: r'rankingRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$rankingRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RankingRepositoryRef = ProviderRef<RankingRepository>;
String _$rankedPlaceIdsHash() => r'9e180452619d33f5432f22877c569c35a08fb272';

/// See also [rankedPlaceIds].
@ProviderFor(rankedPlaceIds)
final rankedPlaceIdsProvider = AutoDisposeStreamProvider<List<String>>.internal(
  rankedPlaceIds,
  name: r'rankedPlaceIdsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$rankedPlaceIdsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RankedPlaceIdsRef = AutoDisposeStreamProviderRef<List<String>>;
String _$rankedDiscoverFeedHash() =>
    r'd9ff439e019ab454e5aa89322300e6e7636c232d';

/// Returns AI-ranked discover feed when available, otherwise falls back to
/// the recency-sorted [discoverFeedProvider] list.
///
/// Copied from [rankedDiscoverFeed].
@ProviderFor(rankedDiscoverFeed)
final rankedDiscoverFeedProvider =
    AutoDisposeFutureProvider<List<Place>>.internal(
      rankedDiscoverFeed,
      name: r'rankedDiscoverFeedProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$rankedDiscoverFeedHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RankedDiscoverFeedRef = AutoDisposeFutureProviderRef<List<Place>>;
String _$refreshRankingHash() => r'166fddbf42df8774b4ce25564dea70853777d77f';

/// See also [RefreshRanking].
@ProviderFor(RefreshRanking)
final refreshRankingProvider =
    AutoDisposeNotifierProvider<RefreshRanking, void>.internal(
      RefreshRanking.new,
      name: r'refreshRankingProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$refreshRankingHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$RefreshRanking = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
