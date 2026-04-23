import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';
import '../domain/app_user.dart';
import '../domain/auth_providers.dart';

const _placeTypes = [
  (label: 'Restaurants', icon: Icons.restaurant_outlined),
  (label: 'Cafés', icon: Icons.coffee_outlined),
  (label: 'Bars', icon: Icons.local_bar_outlined),
  (label: 'Viewpoints', icon: Icons.landscape_outlined),
  (label: 'Markets', icon: Icons.storefront_outlined),
  (label: 'Museums', icon: Icons.museum_outlined),
  (label: 'Parks', icon: Icons.park_outlined),
  (label: 'Hidden Gems', icon: Icons.explore_outlined),
];

const _moods = [
  'Romantic',
  'Family',
  'Lively',
  'Peaceful',
  'Foodie',
  'Off-the-beaten-track',
];

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
    final user = ref.watch(authStateProvider).valueOrNull;

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
                      'Hey ${user?.displayName?.split(' ').first ?? 'there'} 👋',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tell us what you love — we\'ll personalise your feed.',
                      style: LALTypography.bodyMedium,
                    ),
                    const SizedBox(height: 32),
                    const Text('What kind of places?',
                        style: LALTypography.labelLarge),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _placeTypes.map((pt) {
                        final sel = _placeTypesSel.contains(pt.label);
                        return _PreferenceChip(
                          label: pt.label,
                          icon: pt.icon,
                          isSelected: sel,
                          onTap: () => setState(() => sel
                              ? _placeTypesSel.remove(pt.label)
                              : _placeTypesSel.add(pt.label)),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 28),
                    const Text('What\'s your vibe?',
                        style: LALTypography.labelLarge),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _moods.map((m) {
                        final sel = _moodsSel.contains(m);
                        return _PreferenceChip(
                          label: m,
                          isSelected: sel,
                          onTap: () => setState(() =>
                              sel ? _moodsSel.remove(m) : _moodsSel.add(m)),
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
                        : const Text('Start exploring'),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => context.go('/discover'),
                    child: Text(
                      'Skip for now',
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
