import 'package:flutter/material.dart';

import '../../theme/tokens.dart';
import '../../theme/typography.dart';

class LALChip extends StatelessWidget {
  const LALChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.leadingIcon,
  });

  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final IconData? leadingIcon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? LALColors.c900 : LALColors.surfaceAlt,
          borderRadius: LALRadii.pillBorder,
          border: Border.all(
            color: isSelected ? LALColors.c900 : LALColors.c200,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leadingIcon != null) ...[
              Icon(
                leadingIcon,
                size: 14,
                color: isSelected ? LALColors.surface : LALColors.c700,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: LALTypography.labelMedium.copyWith(
                color: isSelected ? LALColors.surface : LALColors.c700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FloatChip extends StatelessWidget {
  const FloatChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: const BoxDecoration(
        color: LALColors.surface,
        borderRadius: LALRadii.pillBorder,
      ),
      child: Text(
        label,
        style: LALTypography.labelSmall.copyWith(color: LALColors.c900),
      ),
    );
  }
}

class AccentChip extends StatelessWidget {
  const AccentChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: const BoxDecoration(
        color: LALColors.accentSoft,
        borderRadius: LALRadii.pillBorder,
      ),
      child: Text(
        label,
        style: LALTypography.labelSmall.copyWith(color: LALColors.accentDark),
      ),
    );
  }
}
