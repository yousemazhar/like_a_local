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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(refreshRankingProvider.notifier).refresh();
    });
  }

  Future<void> _refresh() async {
    await ref.read(refreshRankingProvider.notifier).refresh();
    ref.invalidate(smartPickProvider);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final user = ref.watch(currentUserDocProvider).valueOrNull;
    final isPremium = user?.premium ?? false;
    final hasPrefs = (user?.preferences.placeTypes.isNotEmpty ?? false) ||
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
            _PremiumPickSection(isPremium: isPremium),
            const SizedBox(height: LALSpacing.xxl),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: LALSpacing.xl,
              ),
              child: Text(t.smartRecsRanked, style: LALTypography.headlineSmall),
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

class _PremiumPickSection extends ConsumerWidget {
  const _PremiumPickSection({required this.isPremium});

  final bool isPremium;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    final pickAsync = ref.watch(smartPickProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: LALSpacing.xl),
      child: pickAsync.when(
        loading: () => const SkeletonCard(width: double.infinity, height: 220),
        error: (_, __) => const SizedBox.shrink(),
        data: (pick) => pick == null
            ? const SizedBox.shrink()
            : _SmartPickCard(place: pick.place, reason: pick.reason),
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
    return GestureDetector(
      onTap: () => context.push('/place/${place.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: LALColors.surface,
          borderRadius: LALRadii.xlBorder,
          border: Border.all(color: LALColors.accentSoft, width: 2),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CachedNetworkImage(
                    imageUrl: image,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        const ColoredBox(color: LALColors.c100),
                    errorWidget: (_, __, ___) => const ColoredBox(
                      color: LALColors.surfaceAlt,
                      child: Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: LALColors.c300,
                        ),
                      ),
                    ),
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
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.auto_awesome_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          t.smartPickBadge,
                          style: LALTypography.labelSmall.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(LALSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(place.title, style: LALTypography.headlineSmall),
                  const SizedBox(height: 4),
                  Text(
                    place.neighborhood,
                    style: LALTypography.bodySmall,
                  ),
                  const SizedBox(height: LALSpacing.md),
                  Text(
                    reason,
                    style: LALTypography.bodyMedium.copyWith(
                      color: LALColors.c800,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
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
              Expanded(
                child: Text(title, style: LALTypography.labelLarge),
              ),
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
            const Icon(
              Icons.tune_rounded,
              color: LALColors.c400,
              size: 36,
            ),
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
