import 'package:flutter/material.dart';

import '../../theme/tokens.dart';
import '../../theme/typography.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    this.action,
    this.onActionTap,
    this.padding,
  });

  final String title;
  final String? action;
  final VoidCallback? onActionTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ??
          const EdgeInsets.symmetric(horizontal: LALSpacing.xl),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: LALTypography.headlineSmall),
          if (action != null)
            GestureDetector(
              onTap: onActionTap,
              child: Text(
                action!,
                style: LALTypography.labelMedium
                    .copyWith(color: LALColors.accent),
              ),
            ),
        ],
      ),
    );
  }
}
