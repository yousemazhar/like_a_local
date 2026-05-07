import 'package:flutter/material.dart';

import '../../theme/tokens.dart';
import '../../theme/typography.dart';

class LALHeader extends StatelessWidget implements PreferredSizeWidget {
  const LALHeader({
    super.key,
    this.location,
    this.onNotificationsTap,
    this.unreadCount = 0,
  });

  final String? location;
  final VoidCallback? onNotificationsTap;
  final int unreadCount;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: LALColors.surface,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: preferredSize.height,
          padding: const EdgeInsets.symmetric(horizontal: LALSpacing.xl),
          child: Row(
        children: [
          const _LALLogo(),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LikeALocal',
                  style: LALTypography.headlineSmall.copyWith(fontSize: 16),
                ),
                if (location != null)
                  Text(
                    location!.toUpperCase(),
                    style: LALTypography.labelSmall,
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: onNotificationsTap,
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(
                  Icons.notifications_outlined,
                  color: LALColors.c900,
                  size: 24,
                ),
                if (unreadCount > 0)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: LALColors.accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
        ),
      ),
    );
  }
}

class _LALLogo extends StatelessWidget {
  const _LALLogo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: Stack(
        children: [
          Center(
            child: Transform.rotate(
              angle: 0.7854, // 45°
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: LALColors.c900,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 2,
            right: 2,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: LALColors.accent,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
