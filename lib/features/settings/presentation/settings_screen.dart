import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/connectivity_provider.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/widgets/offline_action_snack_bar.dart';
import '../../../features/auth/domain/auth_providers.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';

final _userSettingsStreamProvider =
    StreamProvider.autoDispose<Map<String, dynamic>>((ref) {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return Stream.value(const {});
      return FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .snapshots()
          .map((s) => s.data() ?? const {});
    });

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  void _comingSoon(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text('$label · coming soon'),
      ),
    );
  }

  Future<void> _patch(Map<String, dynamic> patch) async {
    if (ref.read(isOnlineProvider).valueOrNull == false) {
      showOfflineActionSnackBar(context);
      return;
    }
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await ref.read(authRepositoryProvider).updateUserSettings(uid, patch);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider);
    final languageCode = locale.languageCode;
    final settingsAsync = ref.watch(_userSettingsStreamProvider);
    final data = settingsAsync.valueOrNull ?? const <String, dynamic>{};
    final chatSettings =
        (data['chatSettings'] as Map?)?.cast<String, dynamic>() ?? const {};
    final privacy =
        (data['privacy'] as Map?)?.cast<String, dynamic>() ?? const {};
    final prefs =
        (data['preferences'] as Map?)?.cast<String, dynamic>() ?? const {};
    final chatEnabled = (chatSettings['enabled'] as bool?) ?? true;
    final awayMode = (chatSettings['awayMode'] as bool?) ?? false;
    final showLocation = (privacy['shareLocation'] as bool?) ?? true;
    final aiRecommendations = (prefs['aiRecommendations'] as bool?) ?? true;

    return Scaffold(
      backgroundColor: LALColors.bg,
      appBar: AppBar(
        title: Text(t.settingsTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        children: [
          // Chat
          _SectionHeader(t.settingsChat),
          _ToggleTile(
            icon: Icons.chat_bubble_outline,
            title: t.settingsEnableChat,
            subtitle: t.settingsEnableChatSubtitle,
            value: chatEnabled,
            onChanged: (v) => _patch({'chatSettings.enabled': v}),
          ),
          _ToggleTile(
            icon: Icons.do_not_disturb_alt_outlined,
            title: t.settingsAwayMode,
            subtitle: t.settingsAwayModeSubtitle,
            value: awayMode,
            onChanged: (v) => _patch({'chatSettings.awayMode': v}),
          ),
          _ActionTile(
            icon: Icons.schedule_outlined,
            title: t.settingsChatSchedule,
            subtitle: t.settingsChatScheduleSubtitle,
            onTap: () => context.push('/chat-schedule'),
          ),

          // Privacy
          _SectionHeader(t.settingsPrivacy),
          _ToggleTile(
            icon: Icons.location_on_outlined,
            title: t.settingsShareLocation,
            subtitle: t.settingsShareLocationSubtitle,
            value: showLocation,
            onChanged: (v) => _patch({'privacy.shareLocation': v}),
          ),
          _ActionTile(
            icon: Icons.visibility_outlined,
            title: t.settingsWhoCanFindMe,
            subtitle: t.settingsEveryone,
            onTap: () => _comingSoon(t.settingsWhoCanFindMe),
          ),

          // Personalization
          _SectionHeader(t.settingsPersonalization),
          _ToggleTile(
            icon: Icons.auto_awesome_outlined,
            title: t.settingsAiRecommendations,
            subtitle: t.settingsAiRecommendationsSubtitle,
            value: aiRecommendations,
            onChanged: (v) => _patch({'preferences.aiRecommendations': v}),
          ),
          _ActionTile(
            icon: Icons.restaurant_menu_outlined,
            title: t.settingsPrefPlaceTypes,
            subtitle: _placeTypesSummary(t, prefs),
            onTap: () => _editPlaceTypes(prefs),
          ),
          _ActionTile(
            icon: Icons.mood_outlined,
            title: t.settingsPrefMoods,
            subtitle: _moodsSummary(t, prefs),
            onTap: () => _editMoods(prefs),
          ),
          _ActionTile(
            icon: Icons.payments_outlined,
            title: t.settingsPrefBudget,
            subtitle: _budgetSummary(t, prefs),
            onTap: () => _editBudget(prefs),
          ),
          _ActionTile(
            icon: Icons.language_outlined,
            title: t.settingsLanguage,
            subtitle: languageCode == 'de'
                ? t.settingsGermanNative
                : t.settingsEnglish,
            onTap: () => _showLanguagePicker(languageCode),
          ),
          _ActionTile(
            icon: Icons.tune_outlined,
            title: t.settingsPreferences,
            subtitle: t.settingsPreferencesSubtitle,
            onTap: () => context.push('/onboarding'),
          ),

          // Account
          _SectionHeader(t.settingsAccount),
          _ActionTile(
            icon: Icons.logout_rounded,
            title: t.settingsSignOut,
            onTap: _signOut,
            color: LALColors.error,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _showLanguagePicker(String currentCode) {
    final t = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: LALColors.c200,
                borderRadius: LALRadii.pillBorder,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Text('🇬🇧', style: TextStyle(fontSize: 24)),
              title: Text(t.settingsEnglish),
              trailing: currentCode == 'en'
                  ? const Icon(Icons.check_rounded, color: LALColors.accent)
                  : null,
              onTap: () {
                ref.read(localeProvider.notifier).setLocale('en');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Text('🇩🇪', style: TextStyle(fontSize: 24)),
              title: Text(t.settingsGermanNative),
              trailing: currentCode == 'de'
                  ? const Icon(Icons.check_rounded, color: LALColors.accent)
                  : null,
              onTap: () {
                ref.read(localeProvider.notifier).setLocale('de');
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    if (mounted) context.go('/auth/sign-in');
  }

  // ── Preferences ────────────────────────────────────────────────────────────

  static const _placeTypeOptions = <String>[
    'Restaurant',
    'Café',
    'Bar',
    'Viewpoint',
    'Market',
    'Museum',
    'Park',
  ];

  static const _moodOptions = <String>[
    'Romantic',
    'Family',
    'Hidden Gem',
    'Lively',
    'Peaceful',
    'Foodie',
    'Off-the-beaten-track',
  ];

  static const _budgetOptions = <String>['low', 'mid', 'high'];

  String _placeTypesSummary(AppLocalizations t, Map<String, dynamic> prefs) {
    final list = ((prefs['placeTypes'] as List?) ?? const [])
        .cast<String>();
    if (list.isEmpty) return t.settingsPrefNotSet;
    return list.join(', ');
  }

  String _moodsSummary(AppLocalizations t, Map<String, dynamic> prefs) {
    final list = ((prefs['moods'] as List?) ?? const []).cast<String>();
    if (list.isEmpty) return t.settingsPrefNotSet;
    return list.join(', ');
  }

  String _budgetSummary(AppLocalizations t, Map<String, dynamic> prefs) {
    final value = prefs['budget'] as String?;
    return switch (value) {
      'low' => t.budgetLow,
      'mid' => t.budgetMid,
      'high' => t.budgetHigh,
      _ => t.settingsPrefNotSet,
    };
  }

  Future<void> _editPlaceTypes(Map<String, dynamic> prefs) async {
    final initial =
        ((prefs['placeTypes'] as List?) ?? const []).cast<String>().toSet();
    final result = await _showMultiSelectSheet(
      title: AppLocalizations.of(context)!.settingsPrefPlaceTypes,
      options: _placeTypeOptions,
      initial: initial,
    );
    if (result != null) {
      await _patch({'preferences.placeTypes': result.toList()});
    }
  }

  Future<void> _editMoods(Map<String, dynamic> prefs) async {
    final initial =
        ((prefs['moods'] as List?) ?? const []).cast<String>().toSet();
    final result = await _showMultiSelectSheet(
      title: AppLocalizations.of(context)!.settingsPrefMoods,
      options: _moodOptions,
      initial: initial,
    );
    if (result != null) {
      await _patch({'preferences.moods': result.toList()});
    }
  }

  Future<void> _editBudget(Map<String, dynamic> prefs) async {
    final t = AppLocalizations.of(context)!;
    final current = prefs['budget'] as String?;
    final labels = {
      'low': t.budgetLow,
      'mid': t.budgetMid,
      'high': t.budgetHigh,
    };

    final result = await showModalBottomSheet<String?>(
      context: context,
      builder: (sheetCtx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: LALColors.c200,
                borderRadius: LALRadii.pillBorder,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  t.settingsPrefBudget,
                  style: LALTypography.headlineSmall,
                ),
              ),
            ),
            for (final option in _budgetOptions)
              ListTile(
                title: Text(labels[option]!),
                trailing: current == option
                    ? const Icon(Icons.check_rounded, color: LALColors.accent)
                    : null,
                onTap: () => Navigator.of(sheetCtx).pop(option),
              ),
            ListTile(
              title: Text(t.settingsPrefClear),
              onTap: () => Navigator.of(sheetCtx).pop(''),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );

    if (result == null) return;
    await _patch({'preferences.budget': result.isEmpty ? null : result});
  }

  Future<Set<String>?> _showMultiSelectSheet({
    required String title,
    required List<String> options,
    required Set<String> initial,
  }) {
    return showModalBottomSheet<Set<String>>(
      context: context,
      isScrollControlled: true,
      builder: (sheetCtx) {
        final selected = {...initial};
        final t = AppLocalizations.of(sheetCtx)!;
        return StatefulBuilder(
          builder: (_, setSheetState) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: LALColors.c200,
                        borderRadius: LALRadii.pillBorder,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(title, style: LALTypography.headlineSmall),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final option in options)
                        FilterChip(
                          label: Text(option),
                          selected: selected.contains(option),
                          onSelected: (v) => setSheetState(() {
                            if (v) {
                              selected.add(option);
                            } else {
                              selected.remove(option);
                            }
                          }),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(sheetCtx).pop(),
                          child: Text(t.buttonCancel),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: () =>
                              Navigator.of(sheetCtx).pop(selected),
                          child: Text(t.buttonSave),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Text(
        title.toUpperCase(),
        style: LALTypography.labelSmall.copyWith(
          color: LALColors.c500,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: LALColors.surface,
      child: ListTile(
        leading: Icon(icon, color: LALColors.c700, size: 22),
        title: Text(
          title,
          style: LALTypography.bodyMedium.copyWith(color: LALColors.c900),
        ),
        subtitle: subtitle != null
            ? Text(subtitle!, style: LALTypography.bodySmall)
            : null,
        trailing: Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeTrackColor: LALColors.accent,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? LALColors.c700;
    return Container(
      color: LALColors.surface,
      child: ListTile(
        leading: Icon(icon, color: c, size: 22),
        title: Text(
          title,
          style: LALTypography.bodyMedium.copyWith(
            color: color ?? LALColors.c900,
          ),
        ),
        subtitle: subtitle != null
            ? Text(subtitle!, style: LALTypography.bodySmall)
            : null,
        trailing: color == null
            ? const Icon(Icons.chevron_right_rounded, color: LALColors.c300)
            : null,
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      ),
    );
  }
}
