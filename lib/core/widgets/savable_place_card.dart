import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/saved/domain/saved_providers.dart';
import 'place_card.dart';

/// Wraps [PlaceCard] with live save state from Firestore. The heart / bookmark
/// button toggles `saves/{uid}/pins/{placeId}` and a SnackBar is shown so the
/// user has feedback even when the save indicator is offscreen.
class SavablePlaceCard extends ConsumerWidget {
  const SavablePlaceCard({
    super.key,
    required this.placeId,
    required this.imageUrl,
    required this.title,
    required this.neighborhood,
    this.category,
    this.rating,
    this.onTap,
    this.variant = PlaceCardVariant.featured,
  });

  final String placeId;
  final String imageUrl;
  final String title;
  final String neighborhood;
  final String? category;
  final double? rating;
  final VoidCallback? onTap;
  final PlaceCardVariant variant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pinnedAsync = ref.watch(isPlacePinnedProvider(placeId));
    final isSaved = pinnedAsync.valueOrNull ?? false;
    return PlaceCard(
      imageUrl: imageUrl,
      title: title,
      neighborhood: neighborhood,
      category: category,
      rating: rating,
      isSaved: isSaved,
      variant: variant,
      onTap: onTap,
      onSave: () async {
        await ref.read(savedNotifierProvider.notifier).togglePin(placeId);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 1),
            content: Text(isSaved ? 'Removed from saved' : 'Saved'),
          ),
        );
      },
    );
  }
}
