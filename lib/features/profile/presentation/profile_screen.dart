import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: LALColors.bg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: LALColors.surface,
            floating: true,
            title: Text(t.profileTitle,
                style: Theme.of(context).textTheme.headlineSmall),
            actions: [
              IconButton(
                onPressed: () => context.push('/settings'),
                icon: const Icon(Icons.settings_outlined, color: LALColors.c900),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 24),
                _AvatarSection(),
                const SizedBox(height: 20),
                _StatsRow(),
                const SizedBox(height: 16),
                _TrustStrip(),
                if (kDebugMode) ...[
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: OutlinedButton.icon(
                      onPressed: () => context.push('/test-payment'),
                      icon: const Icon(Icons.credit_card),
                      label: Text(t.profileTestPay),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                _PlacesGrid(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Column(
      children: [
        Stack(
          children: [
            const CircleAvatar(
              radius: 48,
              backgroundColor: LALColors.c100,
              child: Icon(Icons.person, color: LALColors.c400, size: 48),
            ),
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: LALColors.accent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.workspace_premium_rounded,
                    color: Colors.white, size: 16),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(t.profileYourName, style: LALTypography.headlineMedium),
        const SizedBox(height: 4),
        Text(t.profileLocation, style: LALTypography.bodySmall),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _StatItem(value: '0', label: t.profileStatPlaces),
        const _Divider(),
        _StatItem(value: '0', label: t.profileStatSaved),
        const _Divider(),
        _StatItem(value: '0', label: t.profileStatHelpful),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: LALTypography.headlineMedium.copyWith(fontSize: 24)),
        const SizedBox(height: 2),
        Text(label, style: LALTypography.bodySmall),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 32, color: LALColors.c100);
  }
}

class _TrustStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: LALColors.surface,
        borderRadius: LALRadii.lgBorder,
      ),
      child: Row(
        children: [
          const Icon(Icons.verified_outlined,
              color: LALColors.accent, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.profileVerified, style: LALTypography.labelLarge),
                Text(t.profileVerifiedBody,
                    style: LALTypography.bodySmall.copyWith(fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlacesGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(t.profileMyPlaces, style: LALTypography.labelLarge),
        ),
        const SizedBox(height: 12),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                const Icon(Icons.add_location_alt_outlined,
                    color: LALColors.c300, size: 40),
                const SizedBox(height: 12),
                Text(t.profileNoPlaces,
                    style: LALTypography.bodyMedium),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
