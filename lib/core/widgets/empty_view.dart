import 'package:flutter/material.dart';

import '../../theme/tokens.dart';
import '../../theme/typography.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({
    super.key,
    required this.title,
    required this.body,
    this.action,
    this.onActionTap,
    this.icon,
  });

  final String title;
  final String body;
  final String? action;
  final VoidCallback? onActionTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
            if (icon != null) ...[
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: LALColors.surfaceAlt,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: LALColors.c400, size: 32),
              ),
              const SizedBox(height: 24),
            ],
            Text(
              title,
              style: LALTypography.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              body,
              style: LALTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
          if (action != null && onActionTap != null) ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onActionTap,
              child: Text(action!),
            ),
          ],
        ],
      ),
    );
  }
}
