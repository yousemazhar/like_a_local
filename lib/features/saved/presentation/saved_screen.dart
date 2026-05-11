import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';
import '../../auth/domain/auth_providers.dart';
import '../../place/domain/place_providers.dart';
import '../../reminders/domain/reminder.dart';
import '../../reminders/domain/reminder_providers.dart';
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
    final t = AppLocalizations.of(context)!;
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
                  Text(t.savedTitle,
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
              tabs: [
                Tab(text: t.savedCollections),
                Tab(text: t.savedAllPlaces),
                Tab(text: t.savedReminders),
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
    final t = AppLocalizations.of(context)!;
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
                      Text(t.savedUnlockCollections,
                          style: LALTypography.labelLarge
                              .copyWith(color: LALColors.accentDark)),
                      const SizedBox(height: 2),
                      Text(t.savedFreePlan,
                          style: LALTypography.bodySmall
                              .copyWith(color: LALColors.accentDark)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => context.push('/premium'),
                  child: Text(t.savedUpgrade,
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
                    title: t.savedNoCollections,
                    body: t.savedNoCollectionsBody,
                    action: t.savedCreateCollection,
                    onActionTap: () => _createCollection(context, ref),
                  )
                : _CollectionsGrid(collections: cols),
          ),
        ],
      ),
    );
  }

  Future<void> _createCollection(BuildContext context, WidgetRef ref) async {
    final t = AppLocalizations.of(context)!;
    final ctrl = TextEditingController();
    try {
      final name = await showDialog<String>(
        context: context,
        builder: (dialogCtx) => AlertDialog(
          title: Text(t.savedNewCollection),
          content: TextField(
            controller: ctrl,
            autofocus: true,
            decoration: InputDecoration(labelText: t.savedCollectionName),
            onSubmitted: (v) => Navigator.of(dialogCtx).pop(v.trim()),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(),
              child: Text(t.buttonCancel),
            ),
            ElevatedButton(
              onPressed: () =>
                  Navigator.of(dialogCtx).pop(ctrl.text.trim()),
              child: Text(t.savedCreate),
            ),
          ],
        ),
      );
      if (name != null && name.isNotEmpty) {
        await ref
            .read(savedNotifierProvider.notifier)
            .createCollection(name);
      }
    } finally {
      ctrl.dispose();
    }
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
    final t = AppLocalizations.of(context)!;
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
                Text(t.savedPlacesCount(collection.count),
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
    final t = AppLocalizations.of(context)!;
    final pinsAsync = ref.watch(savedPinsProvider);

    return pinsAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(20),
        child: SkeletonList(itemCount: 5),
      ),
      error: (_, __) => EmptyView(
        icon: Icons.bookmark_border_rounded,
        title: t.savedEmpty,
        body: t.savedEmptyBody,
      ),
      data: (pins) => pins.isEmpty
          ? EmptyView(
              icon: Icons.bookmark_border_rounded,
              title: t.savedEmpty,
              body: t.savedEmptyBody,
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

class _PinListItem extends ConsumerWidget {
  const _PinListItem({required this.pin});

  final SavedPin pin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final placeAsync = ref.watch(placeDetailProvider(pin.placeId));
    final title = placeAsync.valueOrNull?.title ?? '...';
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
                  Text(title,
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

class _RemindersTab extends ConsumerWidget {
  const _RemindersTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final remindersAsync = ref.watch(remindersStreamProvider);

    return remindersAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(20),
        child: SkeletonList(itemCount: 3),
      ),
      error: (_, __) => EmptyView(
        icon: Icons.notifications_none_rounded,
        title: t.savedNoReminders,
        body: t.savedNoRemindersBody,
      ),
      data: (reminders) => reminders.isEmpty
          ? EmptyView(
              icon: Icons.notifications_none_rounded,
              title: t.savedNoReminders,
              body: t.savedNoRemindersBody,
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: reminders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _ReminderListItem(reminder: reminders[i]),
            ),
    );
  }
}

class _ReminderListItem extends ConsumerWidget {
  const _ReminderListItem({required this.reminder});

  final Reminder reminder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fallbackTitle = reminder.placeTitle ??
        ref
            .watch(placeDetailProvider(reminder.placeId))
            .valueOrNull
            ?.title ??
        '...';
    return GestureDetector(
      onTap: () => context.push('/place/${reminder.placeId}'),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: LALColors.surface,
          borderRadius: LALRadii.lgBorder,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: reminder.enabled
                    ? LALColors.accentSoft
                    : LALColors.surfaceAlt,
                shape: BoxShape.circle,
              ),
              child: Icon(
                reminder.enabled
                    ? Icons.notifications_active
                    : Icons.notifications_off_outlined,
                color: reminder.enabled
                    ? LALColors.accent
                    : LALColors.c400,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fallbackTitle,
                    style: LALTypography.labelMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Within ${reminder.radiusMeters}m',
                    style: LALTypography.bodySmall,
                  ),
                ],
              ),
            ),
            Switch.adaptive(
              value: reminder.enabled,
              activeTrackColor: LALColors.accent,
              onChanged: (v) async {
                final uid = ref.read(authStateProvider).valueOrNull?.uid;
                if (uid == null) return;
                await ref
                    .read(reminderRepositoryProvider)
                    .setEnabled(uid, reminder.placeId, v);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline,
                  color: LALColors.c400, size: 20),
              onPressed: () async {
                final uid = ref.read(authStateProvider).valueOrNull?.uid;
                if (uid == null) return;
                await ref
                    .read(reminderRepositoryProvider)
                    .remove(uid, reminder.placeId);
              },
            ),
          ],
        ),
      ),
    );
  }
}
