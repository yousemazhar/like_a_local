import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/async_error_view.dart';
import '../../../core/widgets/lal_chip.dart';
import '../../../core/widgets/place_card.dart';
import '../../../core/widgets/savable_place_card.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';
import '../../place/domain/place.dart';
import '../../place/domain/place_providers.dart';
import 'filter_sheet.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  String _query = '';
  Timer? _debounce;
  PlaceFilters _filters = const PlaceFilters();

  void _onChanged(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 280), () {
      if (!mounted) return;
      setState(() => _query = v.trim());
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _openFilters() async {
    final result = await FilterSheet.show(context, initial: _filters);
    if (result != null && mounted) {
      setState(() => _filters = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LALColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SearchBar(
              controller: _controller,
              focusNode: _focusNode,
              onChanged: _onChanged,
              onClear: () {
                _debounce?.cancel();
                _controller.clear();
                setState(() => _query = '');
              },
              filterCount: _filters.activeCount,
              onTapFilters: _openFilters,
            ),
            Expanded(
              child: (_query.isEmpty && _filters.isEmpty)
                  ? _EmptySearch(onMoodTap: (moodKey) {
                      setState(() {
                        _filters = _filters.copyWith(
                          moods: {..._filters.moods, moodKey},
                        );
                      });
                    })
                  : _SearchResults(query: _query, filters: _filters),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onClear,
    required this.filterCount,
    required this.onTapFilters,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final int filterCount;
  final VoidCallback onTapFilters;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Container(
      color: LALColors.surface,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              autofocus: false,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: t.searchHint,
                prefixIcon:
                    const Icon(Icons.search, color: LALColors.c400, size: 20),
                suffixIcon: controller.text.isNotEmpty
                    ? IconButton(
                        onPressed: onClear,
                        icon: const Icon(Icons.clear,
                            color: LALColors.c400, size: 18),
                      )
                    : null,
                filled: true,
                fillColor: LALColors.surfaceAlt,
                border: OutlineInputBorder(
                  borderRadius: LALRadii.pillBorder,
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: LALRadii.pillBorder,
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: LALRadii.pillBorder,
                  borderSide:
                      const BorderSide(color: LALColors.c900, width: 1.5),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onTapFilters,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color:
                    filterCount > 0 ? LALColors.c900 : LALColors.surfaceAlt,
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.tune_rounded,
                    color: filterCount > 0 ? Colors.white : LALColors.c700,
                    size: 20,
                  ),
                  if (filterCount > 0)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: LALColors.accent,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '$filterCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptySearch extends StatelessWidget {
  const _EmptySearch({required this.onMoodTap});

  final ValueChanged<String> onMoodTap;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final moods = <({String key, String label, IconData icon})>[
      (key: 'Romantic', label: t.moodRomantic, icon: Icons.favorite_outline),
      (key: 'Family', label: t.moodFamily, icon: Icons.family_restroom),
      (key: 'Hidden Gem', label: t.moodHiddenGem, icon: Icons.star_outline),
      (key: 'Lively', label: t.moodLively, icon: Icons.music_note_outlined),
      (key: 'Peaceful', label: t.moodPeaceful, icon: Icons.spa_outlined),
      (key: 'Foodie', label: t.moodFoodie, icon: Icons.restaurant_outlined),
    ];
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Text(t.searchMoods, style: LALTypography.headlineSmall),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final m in moods)
                  LALChip(
                    label: m.label,
                    leadingIcon: m.icon,
                    onTap: () => onMoodTap(m.key),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SearchResults extends ConsumerWidget {
  const _SearchResults({required this.query, required this.filters});

  final String query;
  final PlaceFilters filters;

  bool _matchesQuery(Place p, String q) {
    if (q.isEmpty) return true;
    final lower = q.toLowerCase();
    return p.title.toLowerCase().contains(lower) ||
        p.neighborhood.toLowerCase().contains(lower) ||
        p.city.toLowerCase().contains(lower) ||
        p.category.toLowerCase().contains(lower) ||
        p.moods.any((m) => m.toLowerCase().contains(lower));
  }

  bool _matchesFilters(Place p) {
    if (filters.categories.isNotEmpty) {
      final match = filters.categories.any((c) =>
          p.category.toLowerCase() == c.toLowerCase() ||
          p.category.toLowerCase().contains(c.toLowerCase()));
      if (!match) return false;
    }
    if (filters.moods.isNotEmpty) {
      final lower = filters.moods.map((m) => m.toLowerCase()).toSet();
      final placeMoods = p.moods.map((m) => m.toLowerCase()).toSet();
      if (placeMoods.intersection(lower).isEmpty) return false;
    }
    if (filters.budget != null) {
      if ((p.priceLevel ?? '') != filters.budget) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    // Pull a broad feed and filter client-side so neighborhood/category/mood
    // matches work without per-field Firestore indexes.
    final feed = ref.watch(discoverFeedProvider);
    return feed.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => AsyncErrorView(
        error: e,
        onRetry: () => ref.invalidate(discoverFeedProvider),
      ),
      data: (places) {
        final results = places
            .where((p) => _matchesQuery(p, query) && _matchesFilters(p))
            .toList(growable: false);
        if (results.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.search_off,
                      color: LALColors.c300, size: 48),
                  const SizedBox(height: 16),
                  Text(t.searchNoResults, style: LALTypography.labelLarge),
                  const SizedBox(height: 8),
                  Text(
                    t.searchNoResultsBody,
                    style: LALTypography.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (_, i) {
            final p = results[i];
            return SavablePlaceCard(
              placeId: p.id,
              imageUrl: p.mediaUrls.isNotEmpty ? p.mediaUrls.first : '',
              title: p.title,
              neighborhood:
                  p.neighborhood.isNotEmpty ? p.neighborhood : p.city,
              rating: p.ratingCount > 0 ? p.ratingAvg : null,
              variant: PlaceCardVariant.searchResult,
              onTap: () => context.push('/place/${p.id}'),
            );
          },
        );
      },
    );
  }
}
