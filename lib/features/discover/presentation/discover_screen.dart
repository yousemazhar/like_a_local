import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/lal_chip.dart';
import '../../../core/widgets/lal_header.dart';
import '../../../core/widgets/place_card.dart';
import '../../../core/widgets/section_title.dart';
import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';

// Placeholder data until Firestore is connected
const _featuredPlaces = [
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

const _categories = [
  'All', 'Restaurant', 'Café', 'Bar', 'Viewpoint', 'Market', 'Museum', 'Park',
];

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  int _selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LALColors.bg,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: LALHeader(
              location: 'Lisbon',
              onNotificationsTap: () => context.push('/notifications'),
            ),
          ),
          SliverToBoxAdapter(child: _SearchPill()),
          SliverToBoxAdapter(child: _FeaturedSection()),
          SliverToBoxAdapter(child: _CategoryChips(
            selected: _selectedCategory,
            onSelect: (i) => setState(() => _selectedCategory = i),
          )),
          SliverToBoxAdapter(child: _TrendingSection()),
          SliverToBoxAdapter(child: _LocalOfWeekCard()),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

class _SearchPill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                'Search restaurants, places…',
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
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: 'Near You', action: 'See all', onActionTap: () => context.push('/map')),
        const SizedBox(height: 12),
        SizedBox(
          height: 360,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: LALSpacing.xl),
            itemCount: _featuredPlaces.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) => PlaceCard(
              imageUrl: _featuredPlaces[i].imageUrl,
              title: _featuredPlaces[i].title,
              neighborhood: _featuredPlaces[i].neighborhood,
              category: _featuredPlaces[i].category,
              onTap: () => context.push('/place/demo-$i'),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({required this.selected, required this.onSelect});

  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: LALSpacing.xl),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) => LALChip(
          label: _categories[i],
          isSelected: selected == i,
          onTap: () => onSelect(i),
        ),
      ),
    );
  }
}

class _TrendingSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const SectionTitle(title: 'Trending Now'),
        const SizedBox(height: 12),
        SizedBox(
          height: 168,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: LALSpacing.xl),
            itemCount: _featuredPlaces.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) => PlaceCard(
              imageUrl: _featuredPlaces[i].imageUrl,
              title: _featuredPlaces[i].title,
              neighborhood: _featuredPlaces[i].neighborhood,
              variant: PlaceCardVariant.trending,
              onTap: () => context.push('/place/demo-$i'),
            ),
          ),
        ),
      ],
    );
  }
}

class _LocalOfWeekCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                        'LOCAL OF THE WEEK',
                        style: LALTypography.labelSmall
                            .copyWith(color: LALColors.accent, letterSpacing: 1),
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
                      'View Profile',
                      style: LALTypography.labelMedium
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            CircleAvatar(
              radius: 44,
              backgroundColor: LALColors.c800,
              child: const Icon(Icons.person, color: LALColors.c400, size: 40),
            ),
          ],
        ),
      ),
    );
  }
}
