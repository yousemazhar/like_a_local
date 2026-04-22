import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';

const _contentOverlap = 22.0;

class PlaceScreen extends StatelessWidget {
  const PlaceScreen({super.key, required this.placeId});

  final String placeId;

  @override
  Widget build(BuildContext context) {
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
                backgroundColor: Colors.white.withOpacity(0.9),
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
                  backgroundColor: Colors.white.withOpacity(0.9),
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
                  Container(color: LALColors.c100),
                  const Center(
                    child: Icon(Icons.image_not_supported_outlined,
                        color: LALColors.c300, size: 40),
                  ),
                  // Image counter
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: LALRadii.pillBorder,
                      ),
                      child: const Text('1 / 3',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500)),
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
                      // Title & category
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: LALSpacing.xl),
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
                              child: const Text('Restaurant',
                                  style: LALTypography.labelSmall),
                            ),
                            const SizedBox(height: 8),
                            Text('Tasca do Chico',
                                style:
                                    Theme.of(context).textTheme.headlineLarge),
                            const SizedBox(height: 4),
                            const Text('Alfama · Lisbon',
                                style: LALTypography.bodySmall),
                            const SizedBox(height: 12),
                            Row(children: [
                              const Icon(Icons.star_rounded,
                                  color: LALColors.accent, size: 16),
                              const SizedBox(width: 4),
                              const Text('4.8',
                                  style: LALTypography.labelMedium),
                              const SizedBox(width: 4),
                              const Text('(47 reviews)',
                                  style: LALTypography.bodySmall),
                            ]),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Tips card
                      _TipsCard(),
                      const SizedBox(height: 20),
                      // Dishes
                      _DishesSection(),
                      const SizedBox(height: 20),
                      // Contributor card
                      _ContributorCard(),
                      const SizedBox(height: 100), // bottom bar clearance
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      // Sticky bottom bar
      bottomNavigationBar: _PlaceBottomBar(),
    );
  }
}

class _TipsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const tips = [
      'Order the bacalhau à brás — it\'s not on the menu but ask for it.',
      'Go early or expect a queue. Worth every minute.',
      'Cash only. There\'s an ATM around the corner.',
    ];
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
          const Text('Local Tips', style: LALTypography.labelLarge),
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
                    child: Text(
                      '${i + 1}',
                      style: LALTypography.labelSmall
                          .copyWith(color: LALColors.c700),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(tips[i], style: LALTypography.bodyMedium),
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

class _DishesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const dishes = [
      (name: 'Bacalhau à Brás', note: 'Off-menu, must ask'),
      (name: 'Pastel de Nata', note: 'Fresh every morning'),
      (name: 'Vinho Verde', note: 'House pour, affordable'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: LALSpacing.xl),
          child: Text('Must-Try Dishes', style: LALTypography.labelLarge),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding:
                const EdgeInsets.symmetric(horizontal: LALSpacing.xl),
            itemCount: dishes.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) => Container(
              width: 140,
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: LALColors.surface,
                borderRadius: LALRadii.lgBorder,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: LALColors.surfaceAlt,
                      borderRadius: LALRadii.mdBorder,
                    ),
                    child: const Icon(Icons.restaurant_menu,
                        color: LALColors.c300, size: 20),
                  ),
                  const SizedBox(height: 8),
                  Text(dishes[i].name,
                      style: LALTypography.labelMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  Text(dishes[i].note,
                      style: LALTypography.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ContributorCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                const Text('João Silva', style: LALTypography.labelLarge),
                Text('Super Local · 23 places',
                    style: LALTypography.bodySmall
                        .copyWith(color: LALColors.accent)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => context.push('/chat/joao-silva'),
            style: ElevatedButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('Chat', style: TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

class _PlaceBottomBar extends StatefulWidget {
  @override
  State<_PlaceBottomBar> createState() => _PlaceBottomBarState();
}

class _PlaceBottomBarState extends State<_PlaceBottomBar> {
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
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
              label: const Text('Remind me near'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => setState(() => _saved = !_saved),
              icon: Icon(
                _saved ? Icons.bookmark : Icons.bookmark_border,
                size: 16,
              ),
              label: Text(_saved ? 'Saved' : 'Save place'),
              style: _saved
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
