import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';

class PlaceFilters {
  const PlaceFilters({
    this.categories = const {},
    this.moods = const {},
    this.budget,
  });

  final Set<String> categories;
  final Set<String> moods;
  final String? budget;

  bool get isEmpty => categories.isEmpty && moods.isEmpty && budget == null;
  int get activeCount =>
      categories.length + moods.length + (budget != null ? 1 : 0);

  PlaceFilters copyWith({
    Set<String>? categories,
    Set<String>? moods,
    Object? budget = _unset,
  }) =>
      PlaceFilters(
        categories: categories ?? this.categories,
        moods: moods ?? this.moods,
        budget: identical(budget, _unset) ? this.budget : budget as String?,
      );

  static const _unset = Object();
}

class FilterSheet extends ConsumerStatefulWidget {
  const FilterSheet({super.key, required this.initial});

  final PlaceFilters initial;

  static Future<PlaceFilters?> show(
    BuildContext context, {
    required PlaceFilters initial,
  }) =>
      showModalBottomSheet<PlaceFilters>(
        context: context,
        isScrollControlled: true,
        backgroundColor: LALColors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: LALRadii.xl),
        ),
        builder: (_) => FilterSheet(initial: initial),
      );

  @override
  ConsumerState<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<FilterSheet> {
  late Set<String> _categories;
  late Set<String> _moods;
  String? _budget;

  @override
  void initState() {
    super.initState();
    _categories = {...widget.initial.categories};
    _moods = {...widget.initial.moods};
    _budget = widget.initial.budget;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final categories = <({String key, String label})>[
      (key: 'Restaurant', label: t.categoryRestaurant),
      (key: 'Café', label: t.categoryCafe),
      (key: 'Bar', label: t.categoryBar),
      (key: 'Viewpoint', label: t.categoryViewpoint),
      (key: 'Market', label: t.categoryMarket),
      (key: 'Museum', label: t.categoryMuseum),
      (key: 'Park', label: t.categoryPark),
    ];
    final moods = <({String key, String label})>[
      (key: 'Romantic', label: t.moodRomantic),
      (key: 'Family', label: t.moodFamily),
      (key: 'Hidden Gem', label: t.moodHiddenGem),
      (key: 'Lively', label: t.moodLively),
      (key: 'Peaceful', label: t.moodPeaceful),
      (key: 'Foodie', label: t.moodFoodie),
    ];
    const budgets = ['\$', '\$\$', '\$\$\$', '\$\$\$\$'];

    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: LALColors.c200,
                borderRadius: LALRadii.pillBorder,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                children: [
                  Text('Filters', style: LALTypography.headlineSmall),
                  const Spacer(),
                  TextButton(
                    onPressed: () => setState(() {
                      _categories.clear();
                      _moods.clear();
                      _budget = null;
                    }),
                    child: const Text('Clear'),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Place type', style: LALTypography.labelLarge),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final c in categories)
                          _ChipBtn(
                            label: c.label,
                            selected: _categories.contains(c.key),
                            onTap: () => setState(() {
                              if (_categories.contains(c.key)) {
                                _categories.remove(c.key);
                              } else {
                                _categories.add(c.key);
                              }
                            }),
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text('Mood', style: LALTypography.labelLarge),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final m in moods)
                          _ChipBtn(
                            label: m.label,
                            selected: _moods.contains(m.key),
                            onTap: () => setState(() {
                              if (_moods.contains(m.key)) {
                                _moods.remove(m.key);
                              } else {
                                _moods.add(m.key);
                              }
                            }),
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text('Budget', style: LALTypography.labelLarge),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final b in budgets)
                          _ChipBtn(
                            label: b,
                            selected: _budget == b,
                            onTap: () => setState(() {
                              _budget = _budget == b ? null : b;
                            }),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _apply,
                  child: const Text('Apply'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PlaceFilters _current() => PlaceFilters(
        categories: {..._categories},
        moods: {..._moods},
        budget: _budget,
      );

  void _apply() => Navigator.of(context).pop(_current());
}

class _ChipBtn extends StatelessWidget {
  const _ChipBtn({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? LALColors.c900 : LALColors.surfaceAlt,
          borderRadius: LALRadii.pillBorder,
          border: Border.all(
            color: selected ? LALColors.c900 : LALColors.c200,
          ),
        ),
        child: Text(
          label,
          style: LALTypography.labelMedium.copyWith(
            color: selected ? Colors.white : LALColors.c700,
          ),
        ),
      ),
    );
  }
}
