import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/lal_chip.dart';
import '../../../core/widgets/place_card.dart';
import '../../../core/widgets/savable_place_card.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';
import '../../place/domain/place.dart';
import '../../place/domain/place_providers.dart';

const _recentSearches = ['Restaurants', 'Cafes', 'Viewpoints'];

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  String _query = '';
  Timer? _debounce;

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
            ),
            Expanded(
              child: _query.isEmpty
                  ? _EmptySearch(onRecentTap: (s) {
                      _controller.text = s;
                      setState(() => _query = s);
                    })
                  : _SearchResults(query: _query),
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
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Container(
      color: LALColors.surface,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
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
                  icon: const Icon(Icons.clear, color: LALColors.c400, size: 18),
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
            borderSide: const BorderSide(color: LALColors.c900, width: 1.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}

class _EmptySearch extends StatelessWidget {
  const _EmptySearch({required this.onRecentTap});

  final ValueChanged<String> onRecentTap;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final moods = <({String label, IconData icon})>[
      (label: t.moodRomantic, icon: Icons.favorite_outline),
      (label: t.moodFamily, icon: Icons.family_restroom),
      (label: t.moodHiddenGem, icon: Icons.star_outline),
      (label: t.moodLively, icon: Icons.music_note_outlined),
      (label: t.moodPeaceful, icon: Icons.spa_outlined),
      (label: t.moodFoodie, icon: Icons.restaurant_outlined),
    ];
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent searches
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Text(t.searchRecent, style: LALTypography.headlineSmall),
          ),
          for (final s in _recentSearches)
            ListTile(
              leading: const Icon(Icons.history, color: LALColors.c400, size: 20),
              title: Text(s, style: LALTypography.bodyMedium),
              onTap: () => onRecentTap(s),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              minLeadingWidth: 20,
            ),
          const Divider(height: 24),
          // Mood grid
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Text(t.searchMoods, style: LALTypography.headlineSmall),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final m in moods)
                  LALChip(label: m.label, leadingIcon: m.icon),
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
  const _SearchResults({required this.query});

  final String query;

  bool _matches(Place p, String q) {
    final lower = q.toLowerCase();
    return p.title.toLowerCase().contains(lower) ||
        p.neighborhood.toLowerCase().contains(lower) ||
        p.city.toLowerCase().contains(lower) ||
        p.category.toLowerCase().contains(lower) ||
        p.moods.any((m) => m.toLowerCase().contains(lower));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    if (query.length < 2) {
      return _emptyHint(t);
    }
    // Pull a broad feed and filter client-side so neighborhood/category/mood
    // matches work without per-field Firestore indexes.
    final feed = ref.watch(discoverFeedProvider);
    return feed.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text('$e', style: LALTypography.bodySmall),
        ),
      ),
      data: (places) {
        final results =
            places.where((p) => _matches(p, query)).toList(growable: false);
        if (results.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.search_off, color: LALColors.c300, size: 48),
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

  Widget _emptyHint(AppLocalizations t) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            t.searchHint,
            style: LALTypography.bodySmall,
            textAlign: TextAlign.center,
          ),
        ),
      );
}
