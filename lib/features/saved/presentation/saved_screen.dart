import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';
import '../domain/saved_pin.dart';
import '../domain/saved_providers.dart';

class SavedScreen extends ConsumerStatefulWidget {
  const SavedScreen({super.key});

  @override
  ConsumerState<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends ConsumerState<SavedScreen>
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
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Text('Saved',
                      style: Theme.of(context).textTheme.headlineLarge),
                  const Spacer(),
                  IconButton(
                    onPressed: () => context.push('/add-place'),
                    icon:
                        const Icon(Icons.add_circle_outline, color: LALColors.c900),
                  ),
                ],
              ),
            ),
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

class _CollectionsTab extends ConsumerWidget {
  const _CollectionsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectionsAsync = ref.watch(savedCollectionsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Premium nag
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
          const SizedBox(height: 20),
          collectionsAsync.when(
            loading: () => const SkeletonList(itemCount: 3),
            error: (_, __) => const SizedBox.shrink(),
            data: (cols) => cols.isEmpty
                ? EmptyView(
                    icon: Icons.collections_bookmark_outlined,
                    title: 'No collections yet',
                    body: 'Group your saved places into collections.',
                    action: 'Create collection',
                    onActionTap: () => _createCollection(context, ref),
                  )
                : _CollectionsGrid(collections: cols),
          ),
        ],
      ),
    );
  }

  void _createCollection(BuildContext context, WidgetRef ref) {
    final ctrl = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New collection'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Collection name'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (ctrl.text.trim().isEmpty) return;
              Navigator.pop(context);
              await ref
                  .read(savedNotifierProvider.notifier)
                  .createCollection(ctrl.text.trim());
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

class _CollectionsGrid extends StatelessWidget {
  const _CollectionsGrid({required this.collections});

  final List<SavedCollection> collections;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: collections.length,
      itemBuilder: (_, i) => _CollectionCard(collection: collections[i]),
    );
  }
}

class _CollectionCard extends StatelessWidget {
  const _CollectionCard({required this.collection});

  final SavedCollection collection;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: LALColors.surface,
        borderRadius: LALRadii.lgBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: LALColors.surfaceAlt,
                borderRadius: BorderRadius.vertical(top: LALRadii.lg),
              ),
              child: const Center(
                child: Icon(Icons.collections_bookmark_outlined,
                    color: LALColors.c300, size: 32),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(collection.name,
                    style: LALTypography.labelMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text('${collection.count} places',
                    style: LALTypography.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AllPlacesTab extends ConsumerWidget {
  const _AllPlacesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pinsAsync = ref.watch(savedPinsProvider);

    return pinsAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(20),
        child: SkeletonList(itemCount: 5),
      ),
      error: (_, __) => const EmptyView(
        icon: Icons.bookmark_border_rounded,
        title: 'Nothing saved yet',
        body: 'Save places you love to find them later.',
      ),
      data: (pins) => pins.isEmpty
          ? const EmptyView(
              icon: Icons.bookmark_border_rounded,
              title: 'Nothing saved yet',
              body: 'Save places you love to find them later.',
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: pins.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _PinListItem(pin: pins[i]),
            ),
    );
  }
}

class _PinListItem extends StatelessWidget {
  const _PinListItem({required this.pin});

  final SavedPin pin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/place/${pin.placeId}'),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: LALColors.surface,
          borderRadius: LALRadii.lgBorder,
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: LALColors.surfaceAlt,
                borderRadius: LALRadii.mdBorder,
              ),
              child: const Icon(Icons.place_outlined,
                  color: LALColors.c300, size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pin.placeId,
                      style: LALTypography.labelMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  if (pin.note != null) ...[
                    const SizedBox(height: 2),
                    Text(pin.note!,
                        style: LALTypography.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: LALColors.c400, size: 20),
          ],
        ),
      ),
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
