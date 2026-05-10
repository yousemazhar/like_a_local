import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';
import '../../auth/domain/auth_providers.dart';
import '../../payments/data/payment_repository.dart';

class PremiumScreen extends ConsumerStatefulWidget {
  const PremiumScreen({super.key});

  @override
  ConsumerState<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends ConsumerState<PremiumScreen> {
  bool _yearlySelected = true;
  bool _busy = false;

  Future<void> _purchase() async {
    setState(() => _busy = true);
    try {
      await ref
          .read(paymentRepositoryProvider)
          .runTestCheckout(plan: _yearlySelected ? 'yearly' : 'monthly');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 3),
          content: Text(
            'Payment submitted — your premium status will activate shortly.',
          ),
        ),
      );
    } on StripeException catch (e) {
      if (!mounted) return;
      final code = e.error.code.toString();
      // User cancelled — silent.
      if (code.toLowerCase().contains('cancel')) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Payment failed: ${e.error.localizedMessage ?? e.error.code}'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment error: $e')),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final premium =
        ref.watch(currentUserDocProvider).valueOrNull?.premium ?? false;

    final features = [
      (icon: Icons.bookmark_border, text: t.premiumFeatureUnlimitedSaves),
      (icon: Icons.collections_bookmark_outlined, text: t.premiumFeatureUnlimitedCollections),
      (icon: Icons.auto_awesome_outlined, text: t.premiumFeatureAiChat),
      (icon: Icons.wifi_off_rounded, text: t.premiumFeatureOfflineMaps),
      (icon: Icons.notifications_active_outlined, text: t.premiumFeatureReminders),
    ];

    return Scaffold(
      backgroundColor: LALColors.c900,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: LALColors.accent.withValues(alpha: 0.2),
                  borderRadius: LALRadii.pillBorder,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      premium
                          ? Icons.check_circle_rounded
                          : Icons.workspace_premium_rounded,
                      color: LALColors.accent,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      premium ? 'PREMIUM · ACTIVE' : t.premiumBadge,
                      style: LALTypography.labelSmall
                          .copyWith(color: LALColors.accent, letterSpacing: 1.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Headline
              RichText(
                text: TextSpan(
                  style: LALTypography.displayMedium.copyWith(color: Colors.white),
                  children: [
                    TextSpan(text: t.premiumHeadlinePrefix),
                    TextSpan(
                      text: t.premiumHeadlineAccent,
                      style: const TextStyle(
                        color: LALColors.accent,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    TextSpan(text: t.premiumHeadlineSuffix),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Feature list
              for (final f in features) _FeatureRow(feature: f),
              const SizedBox(height: 32),
              if (!premium) ...[
                // Plan cards
                Row(
                  children: [
                    Expanded(
                      child: _PlanCard(
                        title: t.premiumMonthly,
                        price: t.premiumPriceMonthly,
                        period: t.premiumPeriod,
                        isSelected: !_yearlySelected,
                        onTap: () => setState(() => _yearlySelected = false),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _PlanCard(
                        title: t.premiumYearly,
                        price: t.premiumPriceYearly,
                        period: t.premiumPeriod,
                        badge: t.premiumYearlyBadge,
                        isSelected: _yearlySelected,
                        onTap: () => setState(() => _yearlySelected = true),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // CTA
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _busy ? null : _purchase,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: LALColors.accent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                    ),
                    child: _busy
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(t.premiumCta,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: TextButton(
                    onPressed: _busy ? null : _purchase,
                    child: Text(
                      t.premiumRestorePurchases,
                      style: LALTypography.bodySmall
                          .copyWith(color: LALColors.c400),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    _yearlySelected
                        ? t.premiumCancelAnnually
                        : t.premiumCancelMonthly,
                    style: LALTypography.bodySmall
                        .copyWith(color: LALColors.c600),
                    textAlign: TextAlign.center,
                  ),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: LALColors.accent.withValues(alpha: 0.15),
                    borderRadius: LALRadii.lgBorder,
                    border: Border.all(color: LALColors.accent),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.workspace_premium_rounded,
                          color: LALColors.accent, size: 28),
                      const SizedBox(height: 8),
                      Text(
                        "You're all set",
                        style: LALTypography.headlineSmall
                            .copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'All premium features are unlocked. Thanks for supporting locals.',
                        style: LALTypography.bodySmall
                            .copyWith(color: LALColors.c300),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: LALColors.accent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                    ),
                    child: const Text('Done',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.feature});

  final ({IconData icon, String text}) feature;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: LALColors.accent.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(feature.icon, color: LALColors.accent, size: 16),
          ),
          const SizedBox(width: 14),
          Text(
            feature.text,
            style: LALTypography.bodyLarge.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.title,
    required this.price,
    required this.period,
    required this.isSelected,
    required this.onTap,
    this.badge,
  });

  final String title;
  final String price;
  final String period;
  final bool isSelected;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? LALColors.accent.withValues(alpha: 0.15)
              : LALColors.c800,
          borderRadius: LALRadii.lgBorder,
          border: Border.all(
            color: isSelected ? LALColors.accent : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (badge != null)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: LALColors.accent,
                  borderRadius: LALRadii.pillBorder,
                ),
                child: Text(
                  badge!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            Text(title,
                style: LALTypography.labelMedium
                    .copyWith(color: LALColors.c300)),
            const SizedBox(height: 6),
            Text(price,
                style: LALTypography.headlineMedium
                    .copyWith(color: Colors.white)),
            Text(period,
                style: LALTypography.bodySmall
                    .copyWith(color: LALColors.c400)),
          ],
        ),
      ),
    );
  }
}
