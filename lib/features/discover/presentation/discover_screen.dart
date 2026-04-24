import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/lal_chip.dart';
import '../../../core/widgets/lal_header.dart';
import '../../../core/widgets/offline_banner.dart';
import '../../../core/widgets/place_card.dart';
import '../../../core/widgets/section_title.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../features/place/domain/place.dart';
import '../../../features/place/domain/place_providers.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';

const _demoPlaces = [
  (
    title: 'Tasca do Chico',
    neighborhood: 'Alfama',
    category: 'Restaurant',
    imageUrl:
        'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=600&q=80',
  ),
  (
    title: 'Miradouro da Graça',
    neighborhood: 'Graça',
    category: 'Viewpoint',
    imageUrl:
        'https://images.unsplash.com/photo-1534430480872-3498386e7856?w=600&q=80',
  ),
  (
    title: 'LX Factory',
    neighborhood: 'Alcântara',
    category: 'Market',
    imageUrl:
        'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=600&q=80',
  ),
];

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  int _selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    final featuredAsync = ref.watch(featuredPlacesProvider);
    final trendingAsync = ref.watch(trendingPlacesProvider);

    return Scaffold(
      backgroundColor: LALColors.bg,
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: LALHeader(
                    location: 'Lisbon',
                    onNotificationsTap: () => context.push('/notifications'),
                  ),
                ),
                SliverToBoxAdapter(child: _SearchPill()),
                SliverToBoxAdapter(
                  child: _FeaturedSection(featuredAsync: featuredAsync),
                ),
                SliverToBoxAdapter(
                  child: _CategoryChips(
                    selected: _selectedCategory,
                    onSelect: (i) => setState(() => _selectedCategory = i),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _TrendingSection(trendingAsync: trendingAsync),
                ),
                SliverToBoxAdapter(child: _LocalOfWeekCard()),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchPill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () => context.go('/search'),
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: LALColors.surface,
          borderRadius: LALRadii.pillBorder,
          border: Border.all(color: LALColors.c200),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: LALColors.c400, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                t.discoverSearchHint,
                style: LALTypography.bodyMedium.copyWith(color: LALColors.c400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedSection extends StatelessWidget {
  const _FeaturedSection({required this.featuredAsync});

  final AsyncValue<List<Place>> featuredAsync;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: t.discoverNearYou,
          action: t.discoverSeeAll,
          onActionTap: () => context.push('/map'),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 360,
          child: featuredAsync.when(
            loading: () => SkeletonList(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              padding: const EdgeInsets.symmetric(horizontal: LALSpacing.xl),
              itemBuilder: (_, __) =>
                  const SkeletonCard(width: 240, height: 340),
            ),
            error: (_, __) => _demoFeaturedList(context),
            data: (places) => places.isEmpty
                ? _demoFeaturedList(context)
                : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: LALSpacing.xl),
                    itemCount: places.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (_, i) => PlaceCard(
                      imageUrl: places[i].mediaUrls.isNotEmpty
                          ? places[i].mediaUrls.first
                          : '',
                      title: places[i].title,
                      neighborhood: places[i].neighborhood,
                      category: places[i].category,
                      rating: places[i].ratingAvg > 0
                          ? places[i].ratingAvg
                          : null,
                      onTap: () => context.push('/place/${places[i].id}'),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _demoFeaturedList(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: LALSpacing.xl),
      itemCount: _demoPlaces.length,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (_, i) => PlaceCard(
        imageUrl: _demoPlaces[i].imageUrl,
        title: _demoPlaces[i].title,
        neighborhood: _demoPlaces[i].neighborhood,
        category: _demoPlaces[i].category,
        onTap: () => context.push('/place/demo-$i'),
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({required this.selected, required this.onSelect});

  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final categories = <String>[
      t.categoryAll,
      t.categoryRestaurant,
      t.categoryCafe,
      t.categoryBar,
      t.categoryViewpoint,
      t.categoryMarket,
      t.categoryMuseum,
      t.categoryPark,
    ];
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: LALSpacing.xl),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) => LALChip(
          label: categories[i],
          isSelected: selected == i,
          onTap: () => onSelect(i),
        ),
      ),
    );
  }
}

class _TrendingSection extends StatelessWidget {
  const _TrendingSection({required this.trendingAsync});

  final AsyncValue<List<Place>> trendingAsync;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        SectionTitle(title: t.discoverTrending),
        const SizedBox(height: 12),
        SizedBox(
          height: 168,
          child: trendingAsync.when(
            loading: () => SkeletonList(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              padding:
                  const EdgeInsets.symmetric(horizontal: LALSpacing.xl),
              itemBuilder: (_, __) =>
                  const SkeletonCard(width: 200, height: 148),
            ),
            error: (_, __) => _demoTrendingList(context),
            data: (places) => places.isEmpty
                ? _demoTrendingList(context)
                : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: LALSpacing.xl),
                    itemCount: places.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (_, i) => PlaceCard(
                      imageUrl: places[i].mediaUrls.isNotEmpty
                          ? places[i].mediaUrls.first
                          : '',
                      title: places[i].title,
                      neighborhood: places[i].neighborhood,
                      variant: PlaceCardVariant.trending,
                      onTap: () => context.push('/place/${places[i].id}'),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _demoTrendingList(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: LALSpacing.xl),
      itemCount: _demoPlaces.length,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (_, i) => PlaceCard(
        imageUrl: _demoPlaces[i].imageUrl,
        title: _demoPlaces[i].title,
        neighborhood: _demoPlaces[i].neighborhood,
        variant: PlaceCardVariant.trending,
        onTap: () => context.push('/place/demo-$i'),
      ),
    );
  }
}

class _LocalOfWeekCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () => context.push('/place/local-of-week'),
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 24, 20, 0),
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: LALColors.c900,
          borderRadius: LALRadii.xlBorder,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.workspace_premium_rounded,
                          color: LALColors.accent, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        t.discoverLocalOfWeekBadge,
                        style: LALTypography.labelSmall.copyWith(
                            color: LALColors.accent, letterSpacing: 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Maria from Alfama',
                    style: LALTypography.headlineMedium
                        .copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '23 places shared · 4.9 ★',
                    style: LALTypography.bodySmall
                        .copyWith(color: LALColors.c300),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: LALColors.accent,
                      borderRadius: LALRadii.pillBorder,
                    ),
                    child: Text(
                      t.discoverViewProfile,
                      style:
                          LALTypography.labelMedium.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            const CircleAvatar(
              radius: 44,
              backgroundColor: LALColors.c800,
              child: Icon(Icons.person, color: LALColors.c400, size: 40),
            ),
          ],
        ),
      ),
    );
  }
}
