import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/lal_chip.dart';
import '../../../core/widgets/place_card.dart';
import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';

const _moods = [
  (label: 'Romantic', icon: Icons.favorite_outline),
  (label: 'Family', icon: Icons.family_restroom),
  (label: 'Hidden Gem', icon: Icons.star_outline),
  (label: 'Lively', icon: Icons.music_note_outlined),
  (label: 'Peaceful', icon: Icons.spa_outlined),
  (label: 'Foodie', icon: Icons.restaurant_outlined),
];

const _recentSearches = ['Alfama restaurants', 'Viewpoints', 'Sunday market'];

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  String _query = '';

  @override
  void dispose() {
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
              onChanged: (v) => setState(() => _query = v),
              onClear: () {
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
    return Container(
      color: LALColors.surface,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        autofocus: false,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search places, neighborhoods…',
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
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent searches
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Text('Recent', style: LALTypography.headlineSmall),
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
            child: Text('Explore by Mood', style: LALTypography.headlineSmall),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final m in _moods)
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

class _SearchResults extends StatelessWidget {
  const _SearchResults({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with Firestore search results
    final results = [
      (title: 'Tasca do Chico', neighborhood: 'Alfama', rating: 4.8,
       imageUrl: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=300&q=80'),
      (title: 'Time Out Market', neighborhood: 'Cais do Sodré', rating: 4.6,
       imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=300&q=80'),
    ];

    if (results.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off, color: LALColors.c300, size: 48),
              SizedBox(height: 16),
              Text('No places found', style: LALTypography.labelLarge),
              SizedBox(height: 8),
              Text(
                'Try different keywords or remove some filters.',
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
      itemBuilder: (_, i) => PlaceCard(
        imageUrl: results[i].imageUrl,
        title: results[i].title,
        neighborhood: results[i].neighborhood,
        rating: results[i].rating,
        variant: PlaceCardVariant.searchResult,
        onTap: () => context.push('/place/search-$i'),
      ),
    );
  }
}
