import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/async_error_view.dart';
import '../../../core/widgets/lal_state_view.dart';
import '../../../core/widgets/savable_place_card.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';
import '../../auth/domain/app_user.dart';
import '../../place/domain/place.dart';
import '../domain/super_user_providers.dart';

class PublicUserProfileScreen extends ConsumerWidget {
  const PublicUserProfileScreen({super.key, required this.uid});

  final String uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final userAsync = ref.watch(publicUserProvider(uid));
    final placesAsync = ref.watch(publicUserPlacesProvider(uid));

    return Scaffold(
      backgroundColor: LALColors.bg,
      appBar: AppBar(
        title: Text(t.publicProfileTitle),
        backgroundColor: LALColors.surface,
      ),
      body: userAsync.when(
        loading: () => const _ProfileLoading(),
        error: (e, __) => AsyncErrorView(
          error: e,
          onRetry: () => ref.invalidate(publicUserProvider(uid)),
        ),
        data: (user) => user == null
            ? LALStateView(
                kind: LALStateKind.notFound,
                title: t.publicProfileNotFound,
                body: t.publicProfileNotFoundBody,
              )
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _ProfileHeader(user: user)),
                  SliverToBoxAdapter(child: _StatsRow(user: user)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                      child: Text(
                        t.publicProfilePlaces,
                        style: LALTypography.labelLarge,
                      ),
                    ),
                  ),
                  _PlacesSliver(placesAsync: placesAsync),
                  const SliverToBoxAdapter(child: SizedBox(height: 32)),
                ],
              ),
      ),
    );
  }
}

class _ProfileLoading extends StatelessWidget {
  const _ProfileLoading();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(LALSpacing.xl),
      child: Column(
        children: [
          SkeletonBox(width: 96, height: 96),
          SizedBox(height: 16),
          SkeletonBox(width: 180, height: 28),
          SizedBox(height: 24),
          SkeletonBox(width: double.infinity, height: 80),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final photo = user.photoUrl;
    final name = user.displayName?.trim().isNotEmpty == true
        ? user.displayName!
        : (user.email.isNotEmpty
              ? user.email.split('@').first
              : t.placeAnonymous);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 48,
                backgroundColor: LALColors.c100,
                backgroundImage: photo?.isNotEmpty == true
                    ? CachedNetworkImageProvider(photo!)
                    : null,
                child: photo?.isNotEmpty == true
                    ? null
                    : const Icon(Icons.person, color: LALColors.c400, size: 44),
              ),
              if (user.role == 'super')
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: LALColors.accent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.workspace_premium_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text(name, style: LALTypography.headlineMedium),
          const SizedBox(height: 6),
          Text(
            user.role == 'super' ? t.superUsersBadge : t.placeContributor,
            style: LALTypography.labelMedium.copyWith(color: LALColors.accent),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final stats = user.superUserStats;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        color: LALColors.surface,
        borderRadius: LALRadii.lgBorder,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _Stat(
            value: user.superUserScore.toStringAsFixed(0),
            label: t.superUsersScore,
          ),
          const _Divider(),
          _Stat(value: '${stats.placesCount}', label: t.profileStatPlaces),
          const _Divider(),
          _Stat(value: '${stats.reviewsCount}', label: t.placeReviews),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: LALTypography.headlineMedium.copyWith(fontSize: 20)),
        const SizedBox(height: 2),
        Text(label, style: LALTypography.bodySmall),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 32, color: LALColors.c100);
  }
}

class _PlacesSliver extends StatelessWidget {
  const _PlacesSliver({required this.placesAsync});

  final AsyncValue<List<Place>> placesAsync;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return placesAsync.when(
      loading: () => SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: LALSpacing.xl),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, __) => const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: SkeletonCard(width: double.infinity, height: 220),
            ),
            childCount: 2,
          ),
        ),
      ),
      error: (_, __) => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(t.errorGenericBody, textAlign: TextAlign.center),
        ),
      ),
      data: (places) => places.isEmpty
          ? SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  t.publicProfileNoPlaces,
                  textAlign: TextAlign.center,
                  style: LALTypography.bodyMedium,
                ),
              ),
            )
          : SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: LALSpacing.xl),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final place = places[index];
                  return SavablePlaceCard(
                    placeId: place.id,
                    imageUrl: place.mediaUrls.isNotEmpty
                        ? place.mediaUrls.first
                        : '',
                    title: place.title,
                    neighborhood: place.neighborhood,
                    category: place.category,
                    rating: place.ratingAvg > 0 ? place.ratingAvg : null,
                    onTap: () => context.push('/place/${place.id}'),
                  );
                }, childCount: places.length),
              ),
            ),
    );
  }
}
