import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';
import '../domain/app_user.dart';
import '../domain/auth_providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final Set<String> _placeTypesSel = {};
  final Set<String> _moodsSel = {};
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final user = ref.watch(authStateProvider).valueOrNull;

    final placeTypes = <({String key, String label, IconData icon})>[
      (key: 'Restaurants', label: t.placeTypeRestaurants, icon: Icons.restaurant_outlined),
      (key: 'Cafés', label: t.placeTypeCafes, icon: Icons.coffee_outlined),
      (key: 'Bars', label: t.placeTypeBars, icon: Icons.local_bar_outlined),
      (key: 'Viewpoints', label: t.placeTypeViewpoints, icon: Icons.landscape_outlined),
      (key: 'Markets', label: t.placeTypeMarkets, icon: Icons.storefront_outlined),
      (key: 'Museums', label: t.placeTypeMuseums, icon: Icons.museum_outlined),
      (key: 'Parks', label: t.placeTypeParks, icon: Icons.park_outlined),
      (key: 'Hidden Gems', label: t.placeTypeHiddenGems, icon: Icons.explore_outlined),
    ];

    final moods = <({String key, String label})>[
      (key: 'Romantic', label: t.moodRomantic),
      (key: 'Family', label: t.moodFamily),
      (key: 'Lively', label: t.moodLively),
      (key: 'Peaceful', label: t.moodPeaceful),
      (key: 'Foodie', label: t.moodFoodie),
      (key: 'Off-the-beaten-track', label: t.moodOffBeaten),
    ];

    final name = user?.displayName?.split(' ').first ?? t.onboardingDefaultName;

    return Scaffold(
      backgroundColor: LALColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.onboardingGreeting(name),
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      t.onboardingSubtitle,
                      style: LALTypography.bodyMedium,
                    ),
                    const SizedBox(height: 32),
                    Text(t.onboardingPlaceTypes,
                        style: LALTypography.labelLarge),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: placeTypes.map((pt) {
                        final sel = _placeTypesSel.contains(pt.key);
                        return _PreferenceChip(
                          label: pt.label,
                          icon: pt.icon,
                          isSelected: sel,
                          onTap: () => setState(() => sel
                              ? _placeTypesSel.remove(pt.key)
                              : _placeTypesSel.add(pt.key)),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 28),
                    Text(t.onboardingVibe,
                        style: LALTypography.labelLarge),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: moods.map((m) {
                        final sel = _moodsSel.contains(m.key);
                        return _PreferenceChip(
                          label: m.label,
                          isSelected: sel,
                          onTap: () => setState(() =>
                              sel ? _moodsSel.remove(m.key) : _moodsSel.add(m.key)),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  24, 0, 24, 24 + MediaQuery.of(context).padding.bottom),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _loading ? null : _save,
                    child: _loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : Text(t.onboardingStart),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => context.go('/discover'),
                    child: Text(
                      t.onboardingSkip,
                      style: LALTypography.labelMedium
                          .copyWith(color: LALColors.c500),
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

  Future<void> _save() async {
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) {
      context.go('/discover');
      return;
    }

    setState(() => _loading = true);
    try {
      final prefs = UserPreferences(
        placeTypes: _placeTypesSel.toList(),
        moods: _moodsSel.toList(),
      );
      await ref
          .read(authRepositoryProvider)
          .updatePreferences(user.uid, prefs);
    } catch (_) {
    } finally {
      if (mounted) {
        setState(() => _loading = false);
        context.go('/discover');
      }
    }
  }
}

class _PreferenceChip extends StatelessWidget {
  const _PreferenceChip({
    required this.label,
    this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? LALColors.c900 : LALColors.surface,
          borderRadius: LALRadii.pillBorder,
          border: Border.all(
            color: isSelected ? LALColors.c900 : LALColors.c200,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16,
                  color: isSelected ? Colors.white : LALColors.c600),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: LALTypography.labelMedium.copyWith(
                color: isSelected ? Colors.white : LALColors.c700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
