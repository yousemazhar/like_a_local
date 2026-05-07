import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/skeleton.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';
import '../../auth/domain/auth_providers.dart';
import '../../chat/domain/chat_providers.dart';
import '../../reviews/domain/review.dart';
import '../../reviews/domain/review_providers.dart';
import '../../reviews/presentation/review_composer_sheet.dart';
import '../../saved/domain/saved_providers.dart';
import '../domain/place.dart';
import '../domain/place_providers.dart';

const _contentOverlap = 22.0;

class PlaceScreen extends ConsumerWidget {
  const PlaceScreen({super.key, required this.placeId});

  final String placeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final placeAsync = ref.watch(placeDetailProvider(placeId));

    return placeAsync.when(
      loading: () => const _PlaceScaffoldLoading(),
      error: (e, _) => _PlaceScaffoldError(onBack: () => context.pop()),
      data: (place) => place == null
          ? _PlaceScaffoldError(onBack: () => context.pop())
          : _PlaceScaffoldData(place: place),
    );
  }
}

class _PlaceScaffoldLoading extends StatelessWidget {
  const _PlaceScaffoldLoading();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LALColors.bg,
      body: Column(
        children: [
          const SkeletonBox(width: double.infinity, height: 420),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: LALSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SkeletonBox(width: 80, height: 24),
                SizedBox(height: 10),
                SkeletonBox(width: 220, height: 32),
                SizedBox(height: 8),
                SkeletonBox(width: 140, height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceScaffoldError extends StatelessWidget {
  const _PlaceScaffoldError({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: LALColors.bg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: LALColors.c300, size: 48),
              const SizedBox(height: 16),
              Text(t.placeNotFound, style: LALTypography.labelLarge),
              const SizedBox(height: 8),
              Text(
                t.placeNotFoundBody,
                style: LALTypography.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onBack,
                child: Text(t.placeGoBack),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlaceScaffoldData extends ConsumerStatefulWidget {
  const _PlaceScaffoldData({required this.place});

  final Place place;

  @override
  ConsumerState<_PlaceScaffoldData> createState() => _PlaceScaffoldDataState();
}

class _PlaceScaffoldDataState extends ConsumerState<_PlaceScaffoldData> {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final place = widget.place;
    final savedAsync = ref.watch(isPlacePinnedProvider(place.id));
    final isSaved = savedAsync.valueOrNull ?? false;

    return Scaffold(
      backgroundColor: LALColors.bg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 420,
            pinned: true,
            backgroundColor: LALColors.surface,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: Colors.white.withValues(alpha: 0.9),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      size: 16, color: LALColors.c900),
                  onPressed: () => context.pop(),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: CircleAvatar(
                  backgroundColor: Colors.white.withValues(alpha: 0.9),
                  child: IconButton(
                    icon: const Icon(Icons.share_outlined,
                        size: 16, color: LALColors.c900),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (place.mediaUrls.isNotEmpty)
                    Image.network(
                      place.mediaUrls.first,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const _HeroPlaceholder(),
                    )
                  else
                    const _HeroPlaceholder(),
                  if (place.mediaUrls.length > 1)
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: LALRadii.pillBorder,
                        ),
                        child: Text('1 / ${place.mediaUrls.length}',
                            style: LALTypography.labelSmall
                                .copyWith(color: LALColors.surface)),
                      ),
                    ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: _contentOverlap),
              child: Transform.translate(
                offset: const Offset(0, -_contentOverlap),
                child: Container(
                  decoration: const BoxDecoration(
                    color: LALColors.bg,
                    borderRadius: BorderRadius.vertical(top: LALRadii.xl),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: LALSpacing.xl),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: const BoxDecoration(
                                color: LALColors.surfaceAlt,
                                borderRadius: LALRadii.pillBorder,
                              ),
                              child: Text(place.category,
                                  style: LALTypography.labelSmall),
                            ),
                            const SizedBox(height: 8),
                            Text(place.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge),
                            const SizedBox(height: 4),
                            Text(
                              [
                                if (place.neighborhood.isNotEmpty)
                                  place.neighborhood,
                                if (place.city.isNotEmpty) place.city,
                              ].join(' · '),
                              style: LALTypography.bodySmall,
                            ),
                            if (place.ratingAvg > 0) ...[
                              const SizedBox(height: 12),
                              Row(children: [
                                const Icon(Icons.star_rounded,
                                    color: LALColors.accent, size: 16),
                                const SizedBox(width: 4),
                                Text(place.ratingAvg.toStringAsFixed(1),
                                    style: LALTypography.labelMedium),
                                const SizedBox(width: 4),
                                Text(t.placeReviewsCount(place.ratingCount),
                                    style: LALTypography.bodySmall),
                              ]),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (place.tips.isNotEmpty) ...[
                        _TipsCard(tips: place.tips),
                        const SizedBox(height: 20),
                      ],
                      _ContributorCard(
                        ownerDisplayName: place.ownerDisplayName,
                        ownerIsSuper: place.ownerIsSuper,
                        ownerUid: place.ownerUid,
                        placeId: place.id,
                      ),
                      const SizedBox(height: 24),
                      _ReviewsSection(placeId: place.id),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _PlaceBottomBar(
        place: place,
        isSaved: isSaved,
        onToggleSave: () =>
            ref.read(savedNotifierProvider.notifier).togglePin(place.id),
      ),
    );
  }
}

class _HeroPlaceholder extends StatelessWidget {
  const _HeroPlaceholder();

  @override
  Widget build(BuildContext context) => Container(
        color: LALColors.c100,
        child: const Center(
          child: Icon(Icons.image_not_supported_outlined,
              color: LALColors.c300, size: 40),
        ),
      );
}

class _TipsCard extends StatelessWidget {
  const _TipsCard({required this.tips});

  final List<PlaceTip> tips;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: LALSpacing.xl),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: LALColors.surface,
        borderRadius: LALRadii.lgBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.placeTips, style: LALTypography.labelLarge),
          const SizedBox(height: 12),
          for (var i = 0; i < tips.length; i++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: LALColors.surfaceAlt,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text('${i + 1}',
                        style: LALTypography.labelSmall
                            .copyWith(color: LALColors.c700)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(tips[i].text, style: LALTypography.bodyMedium),
                ),
              ],
            ),
            if (i < tips.length - 1) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _ContributorCard extends ConsumerWidget {
  const _ContributorCard({
    required this.ownerDisplayName,
    required this.ownerIsSuper,
    required this.ownerUid,
    required this.placeId,
  });

  final String ownerDisplayName;
  final bool ownerIsSuper;
  final String ownerUid;
  final String placeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: LALSpacing.xl),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: LALColors.surface,
        borderRadius: LALRadii.lgBorder,
      ),
      child: Row(
        children: [
          Stack(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: LALColors.c100,
                child: Icon(Icons.person, color: LALColors.c400),
              ),
              if (ownerIsSuper)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: const BoxDecoration(
                      color: LALColors.accent,
                      shape: BoxShape.circle,
                      border: Border.fromBorderSide(
                          BorderSide(color: Colors.white, width: 1.5)),
                    ),
                    child: const Icon(Icons.workspace_premium_rounded,
                        color: Colors.white, size: 8),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    ownerDisplayName.isNotEmpty
                        ? ownerDisplayName
                        : t.placeAnonymous,
                    style: LALTypography.labelLarge),
                Text(
                  ownerIsSuper ? t.placeSuperLocal : t.placeContributor,
                  style:
                      LALTypography.bodySmall.copyWith(color: LALColors.accent),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: ownerUid.isEmpty
                ? null
                : () async {
                    final threadId = await ref
                        .read(chatNotifierProvider.notifier)
                        .openWithUser(
                          otherUid: ownerUid,
                          otherDisplayName: ownerDisplayName,
                          otherIsSuper: ownerIsSuper,
                          placeContext: placeId,
                        );
                    if (threadId != null && context.mounted) {
                      context.push('/chat/$threadId');
                    }
                  },
            style: ElevatedButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(t.placeChat, style: LALTypography.labelMedium),
          ),
        ],
      ),
    );
  }
}

class _PlaceBottomBar extends StatelessWidget {
  const _PlaceBottomBar({
    required this.place,
    required this.isSaved,
    required this.onToggleSave,
  });

  final Place place;
  final bool isSaved;
  final VoidCallback onToggleSave;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 12, 20, 12 + MediaQuery.of(context).padding.bottom),
      decoration: const BoxDecoration(
        color: LALColors.surface,
        border: Border(top: BorderSide(color: LALColors.c100)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.notifications_outlined, size: 16),
              label: Text(t.placeRemindMe),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onToggleSave,
              icon: Icon(
                isSaved ? Icons.bookmark : Icons.bookmark_border,
                size: 16,
              ),
              label: Text(isSaved ? t.placeSaved : t.placeSave),
              style: isSaved
                  ? ElevatedButton.styleFrom(
                      backgroundColor: LALColors.accentSoft,
                      foregroundColor: LALColors.accentDark,
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewsSection extends ConsumerWidget {
  const _ReviewsSection({required this.placeId});

  final String placeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final reviewsAsync = ref.watch(placeReviewsProvider(placeId));
    final myReview = ref.watch(myPlaceReviewProvider(placeId)).valueOrNull;
    final user = ref.watch(authStateProvider).valueOrNull;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: LALSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(t.placeReviews,
                  style: Theme.of(context).textTheme.headlineSmall),
              const Spacer(),
              if (user != null)
                TextButton.icon(
                  onPressed: () => ReviewComposerSheet.show(
                    context,
                    placeId: placeId,
                    existing: myReview,
                  ),
                  icon: Icon(
                    myReview == null ? Icons.add : Icons.edit_outlined,
                    size: 16,
                  ),
                  label: Text(myReview == null
                      ? t.placeWriteReview
                      : t.placeEditReview),
                ),
            ],
          ),
          const SizedBox(height: 12),
          reviewsAsync.when(
            loading: () =>
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: SkeletonBox(width: double.infinity, height: 80),
                ),
            error: (_, __) => Text(t.placeNoReviews,
                style: LALTypography.bodySmall),
            data: (reviews) => reviews.isEmpty
                ? Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: LALColors.surface,
                      borderRadius: LALRadii.lgBorder,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.placeNoReviews,
                            style: LALTypography.labelLarge),
                        const SizedBox(height: 4),
                        Text(t.placeNoReviewsBody,
                            style: LALTypography.bodySmall),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      for (final r in reviews) ...[
                        _ReviewTile(
                          review: r,
                          isMine: user?.uid == r.authorUid,
                          onDelete: () => ref
                              .read(reviewNotifierProvider.notifier)
                              .delete(placeId, r.id),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({
    required this.review,
    required this.isMine,
    required this.onDelete,
  });

  final Review review;
  final bool isMine;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: LALColors.surface,
        borderRadius: LALRadii.lgBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: LALColors.c100,
                child: Text(
                  review.authorDisplayName.isNotEmpty
                      ? review.authorDisplayName[0].toUpperCase()
                      : '?',
                  style: LALTypography.labelMedium
                      .copyWith(color: LALColors.c600),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.authorDisplayName.isNotEmpty
                          ? review.authorDisplayName
                          : t.placeAnonymous,
                      style: LALTypography.labelMedium,
                    ),
                    Row(
                      children: [
                        for (var i = 1; i <= 5; i++)
                          Icon(
                            i <= review.rating
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            color: LALColors.accent,
                            size: 14,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isMine)
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18),
                  onPressed: onDelete,
                  tooltip: t.placeDeleteReview,
                ),
            ],
          ),
          if (review.text.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(review.text, style: LALTypography.bodyMedium),
          ],
        ],
      ),
    );
  }
}
