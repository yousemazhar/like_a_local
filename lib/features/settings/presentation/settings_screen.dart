import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _chatEnabled = true;
  bool _awayMode = false;
  bool _showLocation = true;
  bool _aiRecommendations = true;
  String _language = 'en';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LALColors.bg,
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        children: [
          // Chat
          _SectionHeader('Chat'),
          _ToggleTile(
            icon: Icons.chat_bubble_outline,
            title: 'Enable chat',
            subtitle: 'Allow contributors to message you',
            value: _chatEnabled,
            onChanged: (v) => setState(() => _chatEnabled = v),
          ),
          _ToggleTile(
            icon: Icons.do_not_disturb_alt_outlined,
            title: 'Away mode',
            subtitle: 'Decline new messages temporarily',
            value: _awayMode,
            onChanged: (v) => setState(() => _awayMode = v),
          ),
          _ActionTile(
            icon: Icons.schedule_outlined,
            title: 'Chat schedule',
            subtitle: 'Set available hours',
            onTap: () {},
          ),

          // Privacy
          _SectionHeader('Privacy'),
          _ToggleTile(
            icon: Icons.location_on_outlined,
            title: 'Share location',
            subtitle: 'Used for Near Me and reminders',
            value: _showLocation,
            onChanged: (v) => setState(() => _showLocation = v),
          ),
          _ActionTile(
            icon: Icons.visibility_outlined,
            title: 'Who can find me',
            subtitle: 'Everyone',
            onTap: () {},
          ),

          // Personalization
          _SectionHeader('Personalization'),
          _ToggleTile(
            icon: Icons.auto_awesome_outlined,
            title: 'AI recommendations',
            subtitle: 'Personalize your feed with Gemini',
            value: _aiRecommendations,
            onChanged: (v) => setState(() => _aiRecommendations = v),
          ),
          _ActionTile(
            icon: Icons.language_outlined,
            title: 'Language',
            subtitle: _language == 'en' ? 'English' : 'Deutsch',
            onTap: _showLanguagePicker,
          ),
          _ActionTile(
            icon: Icons.tune_outlined,
            title: 'Preferences',
            subtitle: 'Place types, mood, budget',
            onTap: () {},
          ),

          // Account
          _SectionHeader('Account'),
          _ActionTile(
            icon: Icons.logout_rounded,
            title: 'Sign out',
            onTap: _signOut,
            color: LALColors.error,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _showLanguagePicker() {
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
              title: const Text('English'),
              trailing: _language == 'en'
                  ? const Icon(Icons.check_rounded, color: LALColors.accent)
                  : null,
              onTap: () {
                setState(() => _language = 'en');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Text('🇩🇪', style: TextStyle(fontSize: 24)),
              title: const Text('Deutsch'),
              trailing: _language == 'de'
                  ? const Icon(Icons.check_rounded, color: LALColors.accent)
                  : null,
              onTap: () {
                setState(() => _language = 'de');
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _signOut() {
    // TODO: FirebaseAuth.instance.signOut() then context.go('/auth/sign-in')
    context.go('/auth/sign-in');
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
