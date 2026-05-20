import 'package:cloud_functions/cloud_functions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/domain/auth_providers.dart';
import '../../place/domain/place.dart';
import '../../place/domain/place_providers.dart';
import '../data/smart_pick_repository.dart';
import 'ranking_providers.dart';

part 'smart_pick_providers.g.dart';

class SmartPick {
  const SmartPick({
    required this.place,
    required this.reason,
    this.fallback = false,
  });

  final Place place;
  final String reason;
  final bool fallback;
}

@Riverpod(keepAlive: true)
SmartPickRepository smartPickRepository(SmartPickRepositoryRef ref) =>
    SmartPickRepository(FirebaseFunctions.instance);

/// Premium-only. Returns `null` for non-premium users.
/// Throws [SmartPickUnavailableException] when Gemini fails — the UI should
/// catch that and silently hide the pick card while keeping the ranked list.
@riverpod
Future<SmartPick?> smartPick(SmartPickRef ref) async {
  final user = ref.watch(currentUserDocProvider).valueOrNull;
  if (user == null || !user.premium) return null;

  final rankedIds = await ref.watch(rankedPlaceIdsProvider.future);
  if (rankedIds.isEmpty) return null;

  final result = await ref.watch(smartPickRepositoryProvider).fetchTopPick();

  final place = await ref
      .watch(placeRepositoryProvider)
      .placeById(result.placeId)
      .first;
  if (place == null) {
    throw const SmartPickUnavailableException('Place not found');
  }
  return SmartPick(
    place: place,
    reason: result.reason,
    fallback: result.fallback,
  );
}
