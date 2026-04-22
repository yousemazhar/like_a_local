import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/empty_view.dart';
import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LALColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Text('Saved', style: Theme.of(context).textTheme.headlineLarge),
                  const Spacer(),
                  IconButton(
                    onPressed: () => context.push('/add-place'),
                    icon: const Icon(Icons.add_circle_outline,
                        color: LALColors.c900),
                  ),
                ],
              ),
            ),
            // Tabs
            TabBar(
              controller: _tabs,
              labelColor: LALColors.c900,
              unselectedLabelColor: LALColors.c500,
              indicatorColor: LALColors.accent,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: LALTypography.labelMedium,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              tabs: const [
                Tab(text: 'Collections'),
                Tab(text: 'All Places'),
                Tab(text: 'Reminders'),
              ],
            ),
            const Divider(height: 1),
            Expanded(
              child: TabBarView(
                controller: _tabs,
                children: const [
                  _CollectionsTab(),
                  _AllPlacesTab(),
                  _RemindersTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CollectionsTab extends StatelessWidget {
  const _CollectionsTab();

  @override
  Widget build(BuildContext context) {
    // Placeholder: show premium nag + empty
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Premium nag card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: LALColors.accentSoft,
              borderRadius: LALRadii.lgBorder,
            ),
            child: Row(
              children: [
                const Icon(Icons.workspace_premium_rounded,
                    color: LALColors.accent),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Unlock unlimited collections',
                          style: LALTypography.labelLarge
                              .copyWith(color: LALColors.accentDark)),
                      const SizedBox(height: 2),
                      Text('Free plan: up to 10 saved places.',
                          style: LALTypography.bodySmall
                              .copyWith(color: LALColors.accentDark)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => context.push('/premium'),
                  child: Text('Upgrade',
                      style: LALTypography.labelMedium
                          .copyWith(color: LALColors.accentDark)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          EmptyView(
            icon: Icons.collections_bookmark_outlined,
            title: 'No collections yet',
            body: 'Group your saved places into collections.',
            action: 'Create collection',
            onActionTap: () {},
          ),
        ],
      ),
    );
  }
}

class _AllPlacesTab extends StatelessWidget {
  const _AllPlacesTab();

  @override
  Widget build(BuildContext context) {
    return const EmptyView(
      icon: Icons.bookmark_border_rounded,
      title: 'Nothing saved yet',
      body: 'Save places you love to find them later.',
    );
  }
}

class _RemindersTab extends StatelessWidget {
  const _RemindersTab();

  @override
  Widget build(BuildContext context) {
    return const EmptyView(
      icon: Icons.notifications_none_rounded,
      title: 'No reminders set',
      body: 'Set location reminders on any saved place.',
    );
  }
}
