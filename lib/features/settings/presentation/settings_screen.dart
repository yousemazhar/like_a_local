import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/locale_provider.dart';
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
  Future<void> _patch(Map<String, dynamic> patch) async {
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
    final aiRecommendations =
        (prefs['aiRecommendations'] as bool?) ?? true;

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
            onTap: () {},
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
            onTap: () {},
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
            onTap: () {},
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
        title: Text(title, style: LALTypography.bodyMedium.copyWith(color: LALColors.c900)),
        subtitle: subtitle != null
            ? Text(subtitle!, style: LALTypography.bodySmall)
            : null,
        trailing: Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeTrackColor: LALColors.accent,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
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
        title: Text(title,
            style: LALTypography.bodyMedium.copyWith(color: color ?? LALColors.c900)),
        subtitle: subtitle != null
            ? Text(subtitle!, style: LALTypography.bodySmall)
            : null,
        trailing: color == null
            ? const Icon(Icons.chevron_right_rounded, color: LALColors.c300)
            : null,
        onTap: onTap,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      ),
    );
  }
}
