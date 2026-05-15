import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';

class SmartSuggestionsBanner extends StatelessWidget {
  const SmartSuggestionsBanner({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        LALSpacing.xl,
        0,
        LALSpacing.xl,
        LALSpacing.lg,
      ),
      child: Material(
        color: LALColors.accentSoft,
        borderRadius: LALRadii.xlBorder,
        child: InkWell(
          onTap: onTap,
          borderRadius: LALRadii.xlBorder,
          child: Padding(
            padding: const EdgeInsets.all(LALSpacing.lg),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: LALColors.accent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.smartSuggestionsTitle,
                        style: LALTypography.labelLarge.copyWith(
                          color: LALColors.accentDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        t.smartSuggestionsSubtitle,
                        style: LALTypography.bodySmall.copyWith(
                          color: LALColors.c700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: LALColors.accentDark,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
