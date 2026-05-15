import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/place_card.dart';
import '../../../core/widgets/savable_place_card.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';
import '../../auth/domain/auth_providers.dart';
import '../../place/domain/place.dart';
import '../domain/ranking_providers.dart';
import '../domain/smart_pick_providers.dart';

class SmartRecommendationsScreen extends ConsumerStatefulWidget {
  const SmartRecommendationsScreen({super.key});

  @override
  ConsumerState<SmartRecommendationsScreen> createState() =>
      _SmartRecommendationsScreenState();
}

class _SmartRecommendationsScreenState
    extends ConsumerState<SmartRecommendationsScreen> {
  AsyncValue<SmartPick?> _smartPick = const AsyncData(null);

  Future<void> _refresh() async {
    await ref.read(refreshRankingProvider.notifier).refresh();
    ref.invalidate(smartPickProvider);
  }

  Future<void> _loadAiPick() async {
    setState(() => _smartPick = const AsyncLoading());
    try {
      await ref.read(refreshRankingProvider.notifier).refresh();
      ref.invalidate(smartPickProvider);
      final pick = await ref.read(smartPickProvider.future);
      if (!mounted) return;
      setState(() => _smartPick = AsyncData(pick));
    } catch (error, stackTrace) {
      debugPrint('AI pick failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (!mounted) return;
      setState(() => _smartPick = AsyncError(error, stackTrace));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final user = ref.watch(currentUserDocProvider).valueOrNull;
    final isPremium = user?.premium ?? false;
    final hasPrefs =
        (user?.preferences.placeTypes.isNotEmpty ?? false) ||
        (user?.preferences.moods.isNotEmpty ?? false) ||
        (user?.preferences.budget != null);
    final rankedAsync = ref.watch(rankedDiscoverFeedProvider);

    return Scaffold(
      backgroundColor: LALColors.bg,
      appBar: AppBar(
        title: Text(t.smartRecsTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _refresh,
            tooltip: t.errorRetry,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: LALSpacing.lg),
          children: [
            _PremiumPickSection(
              isPremium: isPremium,
              pick: _smartPick,
              onPick: _loadAiPick,
            ),
            const SizedBox(height: LALSpacing.xxl),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: LALSpacing.xl),
              child: Text(
                t.smartRecsRanked,
                style: LALTypography.headlineSmall,
              ),
            ),
            const SizedBox(height: LALSpacing.md),
            if (!hasPrefs)
              _EmptyPrefsCard()
            else
              rankedAsync.when(
                loading: () => Column(
                  children: [
                    for (var i = 0; i < 3; i++)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          LALSpacing.xl,
                          0,
                          LALSpacing.xl,
                          LALSpacing.md,
                        ),
                        child: const SkeletonCard(
                          width: double.infinity,
                          height: 100,
                        ),
                      ),
                  ],
                ),
                error: (_, __) => _ErrorCard(onRetry: _refresh),
                data: (places) => places.isEmpty
                    ? _ErrorCard(onRetry: _refresh)
                    : Column(
                        children: [
                          for (final p in places)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                LALSpacing.xl,
                                0,
                                LALSpacing.xl,
                                LALSpacing.md,
                              ),
                              child: SavablePlaceCard(
                                placeId: p.id,
                                imageUrl: p.mediaUrls.isNotEmpty
                                    ? p.mediaUrls.first
                                    : '',
                                title: p.title,
                                neighborhood: p.neighborhood,
                                category: p.category,
                                rating: p.ratingAvg > 0 ? p.ratingAvg : null,
                                variant: PlaceCardVariant.searchResult,
                                onTap: () => context.push('/place/${p.id}'),
                              ),
                            ),
                        ],
                      ),
              ),
            const SizedBox(height: LALSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

class _PremiumPickSection extends StatelessWidget {
  const _PremiumPickSection({
    required this.isPremium,
    required this.pick,
    required this.onPick,
  });

  final bool isPremium;
  final AsyncValue<SmartPick?> pick;
  final Future<void> Function() onPick;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    if (!isPremium) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: LALSpacing.xl),
        child: _PremiumLockedCard(
          title: t.smartPickHeading,
          body: t.smartPickPremiumLocked,
          ctaLabel: t.savedUpgrade,
          onTap: () => context.push('/premium'),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: LALSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FilledButton.icon(
            onPressed: pick.isLoading ? null : onPick,
            icon: const Icon(Icons.auto_awesome_rounded, size: 18),
            label: Text(t.smartPickBadge),
          ),
          const SizedBox(height: LALSpacing.md),
          pick.when(
            loading: () =>
                const SkeletonCard(width: double.infinity, height: 260),
            error: (error, _) => _SmartPickErrorCard(error: error),
            data: (pick) => pick == null
                ? const SizedBox.shrink()
                : _SmartPickCard(place: pick.place, reason: pick.reason),
          ),
        ],
      ),
    );
  }
}

class _SmartPickErrorCard extends StatelessWidget {
  const _SmartPickErrorCard({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(LALSpacing.lg),
      decoration: BoxDecoration(
        color: LALColors.surface,
        borderRadius: LALRadii.xlBorder,
        border: Border.all(color: LALColors.error.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline_rounded, color: LALColors.error),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.smartPickError, style: LALTypography.labelLarge),
                const SizedBox(height: 4),
                Text(
                  error.toString(),
                  style: LALTypography.bodySmall.copyWith(
                    color: LALColors.c700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SmartPickCard extends StatelessWidget {
  const _SmartPickCard({required this.place, required this.reason});

  final Place place;
  final String reason;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final image = place.mediaUrls.isNotEmpty ? place.mediaUrls.first : '';
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push('/place/${place.id}'),
        borderRadius: LALRadii.xlBorder,
        child: Container(
          padding: const EdgeInsets.all(LALSpacing.md),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F1ED),
            borderRadius: LALRadii.xlBorder,
            border: Border.all(color: LALColors.success.withValues(alpha: 0.2)),
            boxShadow: [
              BoxShadow(
                color: LALColors.c900.withValues(alpha: 0.06),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  LALSpacing.md,
                  LALSpacing.sm,
                  LALSpacing.md,
                  LALSpacing.md,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: LALColors.accent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.auto_awesome_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.smartPickHeading,
                            style: LALTypography.labelLarge.copyWith(
                              color: LALColors.c900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            reason,
                            style: LALTypography.bodyMedium.copyWith(
                              color: LALColors.c800,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: LALRadii.lgBorder,
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: _SmartPickImage(
                        imageUrl: image,
                        category: place.category,
                      ),
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: LALColors.accent,
                          borderRadius: LALRadii.pillBorder,
                        ),
                        child: Text(
                          t.smartPickBadge,
                          style: LALTypography.labelSmall.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  LALSpacing.md,
                  LALSpacing.md,
                  LALSpacing.md,
                  LALSpacing.sm,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(place.title, style: LALTypography.headlineSmall),
                          const SizedBox(height: 4),
                          Text(
                            place.neighborhood,
                            style: LALTypography.bodySmall.copyWith(
                              color: LALColors.c700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: LALColors.c600,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SmartPickImage extends StatelessWidget {
  const _SmartPickImage({required this.imageUrl, required this.category});

  final String imageUrl;
  final String category;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return _SmartPickImageFallback(category: category);
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (_, __) => const ColoredBox(color: LALColors.c100),
      errorWidget: (_, __, ___) => _SmartPickImageFallback(category: category),
    );
  }
}

class _SmartPickImageFallback extends StatelessWidget {
  const _SmartPickImageFallback({required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [LALColors.c700, LALColors.accentDark],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white,
              size: 38,
            ),
            if (category.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                category,
                style: LALTypography.labelSmall.copyWith(color: Colors.white),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PremiumLockedCard extends StatelessWidget {
  const _PremiumLockedCard({
    required this.title,
    required this.body,
    required this.ctaLabel,
    required this.onTap,
  });

  final String title;
  final String body;
  final String ctaLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(LALSpacing.lg),
      decoration: BoxDecoration(
        color: LALColors.surface,
        borderRadius: LALRadii.xlBorder,
        border: Border.all(color: LALColors.c100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: LALColors.accentSoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: LALColors.accent,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(title, style: LALTypography.labelLarge)),
            ],
          ),
          const SizedBox(height: LALSpacing.sm),
          Text(body, style: LALTypography.bodySmall),
          const SizedBox(height: LALSpacing.md),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton(onPressed: onTap, child: Text(ctaLabel)),
          ),
        ],
      ),
    );
  }
}

class _EmptyPrefsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: LALSpacing.xl),
      child: Container(
        padding: const EdgeInsets.all(LALSpacing.lg),
        decoration: BoxDecoration(
          color: LALColors.surface,
          borderRadius: LALRadii.xlBorder,
          border: Border.all(color: LALColors.c100),
        ),
        child: Column(
          children: [
            const Icon(Icons.tune_rounded, color: LALColors.c400, size: 36),
            const SizedBox(height: LALSpacing.sm),
            Text(t.smartRecsEmptyPrefs, style: LALTypography.labelLarge),
            const SizedBox(height: 4),
            Text(
              t.smartRecsEmptyPrefsBody,
              textAlign: TextAlign.center,
              style: LALTypography.bodySmall,
            ),
            const SizedBox(height: LALSpacing.md),
            FilledButton(
              onPressed: () => context.push('/settings'),
              child: Text(t.smartRecsSetPreferences),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.onRetry});
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: LALSpacing.xl),
      child: Container(
        padding: const EdgeInsets.all(LALSpacing.lg),
        decoration: BoxDecoration(
          color: LALColors.surface,
          borderRadius: LALRadii.xlBorder,
          border: Border.all(color: LALColors.c100),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              color: LALColors.c400,
              size: 36,
            ),
            const SizedBox(height: LALSpacing.sm),
            Text(t.smartRecsError, style: LALTypography.labelLarge),
            const SizedBox(height: LALSpacing.md),
            TextButton(onPressed: onRetry, child: Text(t.errorRetry)),
          ],
        ),
      ),
    );
  }
}
