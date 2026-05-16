import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/errors/app_exception.dart';
import '../../core/errors/offline_exception.dart';
import '../../features/saved/domain/saved_providers.dart';
import '../../l10n/app_localizations.dart';
import 'lal_toast.dart';
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
        try {
          await ref.read(savedNotifierProvider.notifier).togglePin(placeId);
        } on OfflineException {
          if (!context.mounted) return;
          LALToast.showOffline(context);
          return;
        } on AppException catch (e) {
          if (!context.mounted) return;
          if (e.kind == LALErrorCode.quotaExceeded) {
            _showPinLimitDialog(context);
          } else {
            LALToast.showError(context, e);
          }
          return;
        } catch (e) {
          if (!context.mounted) return;
          LALToast.showError(context, e);
          return;
        }
        if (!context.mounted) return;
        LALToast.show(
          context,
          isSaved ? 'Removed from saved' : 'Saved',
          kind: LALToastKind.success,
          duration: const Duration(seconds: 1),
        );
      },
    );
  }

  void _showPinLimitDialog(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(t.pinFreeLimitTitle),
        content: Text(t.pinFreeLimitBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t.buttonCancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.push('/premium');
            },
            child: Text(t.savedUpgrade),
          ),
        ],
      ),
    );
  }
}
