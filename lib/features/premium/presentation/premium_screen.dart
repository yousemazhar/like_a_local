import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  bool _yearlySelected = true;

  @override
  Widget build(BuildContext context) {
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
                  color: LALColors.accent.withOpacity(0.2),
                  borderRadius: LALRadii.pillBorder,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.workspace_premium_rounded,
                        color: LALColors.accent, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      'PREMIUM',
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
                  children: const [
                    TextSpan(text: 'Unlock the full\n'),
                    TextSpan(
                      text: 'local',
                      style: TextStyle(
                        color: LALColors.accent,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    TextSpan(text: ' experience.'),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Feature list
              for (final f in _features) _FeatureRow(feature: f),
              const SizedBox(height: 32),
              // Plan cards
              Row(
                children: [
                  Expanded(
                    child: _PlanCard(
                      title: 'Monthly',
                      price: '€4.99',
                      period: '/ month',
                      isSelected: !_yearlySelected,
                      onTap: () => setState(() => _yearlySelected = false),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _PlanCard(
                      title: 'Yearly',
                      price: '€2.99',
                      period: '/ month',
                      badge: 'Save 40%',
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
                  onPressed: _purchase,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: LALColors.accent,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  child: const Text('Start Premium',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Restore purchases',
                    style: LALTypography.bodySmall.copyWith(color: LALColors.c400),
                  ),
                ),
              ),
              Center(
                child: Text(
                  'Cancel anytime. Billed ${_yearlySelected ? "annually" : "monthly"}.',
                  style: LALTypography.bodySmall.copyWith(color: LALColors.c600),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _purchase() {
    // TODO: Purchases.purchasePackage(package)
  }

  static const _features = [
    (icon: Icons.bookmark_border, text: 'Unlimited saved places'),
    (icon: Icons.collections_bookmark_outlined, text: 'Unlimited collections'),
    (icon: Icons.auto_awesome_outlined, text: 'Local AI chat assistant'),
    (icon: Icons.wifi_off_rounded, text: 'Offline neighborhood maps'),
    (icon: Icons.notifications_active_outlined, text: 'Location reminders'),
  ];
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
              color: LALColors.accent.withOpacity(0.15),
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
              ? LALColors.accent.withOpacity(0.15)
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
