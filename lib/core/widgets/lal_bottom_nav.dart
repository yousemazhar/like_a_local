import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/tokens.dart';
import '../../theme/typography.dart';

class LALScaffold extends StatelessWidget {
  const LALScaffold({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: LALBottomNav(
        currentIndex: shell.currentIndex,
        onTap: (i) => shell.goBranch(
          i,
          initialLocation: i == shell.currentIndex,
        ),
      ),
    );
  }
}

class LALBottomNav extends StatelessWidget {
  const LALBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final items = <({IconData icon, IconData active, String label})>[
      (icon: Icons.explore_outlined, active: Icons.explore, label: t.tabDiscover),
      (icon: Icons.search_outlined, active: Icons.search, label: t.tabSearch),
      (icon: Icons.bookmark_border, active: Icons.bookmark, label: t.tabSaved),
      (icon: Icons.chat_bubble_outline, active: Icons.chat_bubble, label: t.tabInbox),
      (icon: Icons.person_outline, active: Icons.person, label: t.tabProfile),
    ];
    return Container(
      decoration: const BoxDecoration(
        color: LALColors.surface,
        border: Border(top: BorderSide(color: LALColors.c100, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (var i = 0; i < items.length; i++)
                _NavItem(
                  icon: items[i].icon,
                  activeIcon: items[i].active,
                  label: items[i].label,
                  isActive: currentIndex == i,
                  onTap: () => onTap(i),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? LALColors.c900 : LALColors.c500;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isActive ? activeIcon : icon, color: color, size: 22),
            const SizedBox(height: 2),
            Text(
              label,
              style: LALTypography.labelSmall.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
