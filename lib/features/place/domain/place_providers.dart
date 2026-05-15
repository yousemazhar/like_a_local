import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/place_repository.dart';
import 'place.dart';

part 'place_providers.g.dart';

@Riverpod(keepAlive: true)
PlaceRepository placeRepository(PlaceRepositoryRef ref) =>
    PlaceRepository(FirebaseFirestore.instance);

@riverpod
Stream<List<Place>> discoverFeed(DiscoverFeedRef ref) =>
    ref.watch(placeRepositoryProvider).discoverFeed();

@riverpod
Stream<List<Place>> nearbyPlaces(
  NearbyPlacesRef ref,
  double latitude,
  double longitude,
  double radiusKm,
) => ref
    .watch(placeRepositoryProvider)
    .nearbyCandidates(
      latitude: latitude,
      longitude: longitude,
      radiusKm: radiusKm,
    );

@riverpod
Stream<List<Place>> featuredPlaces(FeaturedPlacesRef ref) =>
    ref.watch(placeRepositoryProvider).featured();

@riverpod
Stream<List<Place>> trendingPlaces(TrendingPlacesRef ref) =>
    ref.watch(placeRepositoryProvider).trending();

@riverpod
Stream<Place?> placeDetail(PlaceDetailRef ref, String id) =>
    ref.watch(placeRepositoryProvider).placeById(id);

@riverpod
Stream<List<Place>> searchPlaces(SearchPlacesRef ref, String query) =>
    ref.watch(placeRepositoryProvider).search(query);
