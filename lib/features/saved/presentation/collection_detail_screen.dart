import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/offline_exception.dart';
import '../../../core/forms/validators.dart';
import '../../../core/providers/connectivity_provider.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/lal_toast.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';
import '../../place/domain/place_providers.dart';
import '../domain/saved_pin.dart';
import '../domain/saved_providers.dart';
import 'collection_pickers.dart';

class CollectionDetailScreen extends ConsumerWidget {
  const CollectionDetailScreen({required this.collectionId, super.key});

  final String collectionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final collectionsAsync = ref.watch(savedCollectionsProvider);
    final pinsAsync = ref.watch(pinsInCollectionProvider(collectionId));

    final collection = collectionsAsync.valueOrNull
        ?.where((c) => c.id == collectionId)
        .cast<SavedCollection?>()
        .firstWhere((_) => true, orElse: () => null);

    if (collectionsAsync.hasValue && collection == null) {
      return Scaffold(
        backgroundColor: LALColors.bg,
        appBar: AppBar(),
        body: EmptyView(
          icon: Icons.collections_bookmark_outlined,
          title: t.collectionNotFound,
          body: t.stateNotFoundBody,
        ),
      );
    }

    return Scaffold(
      backgroundColor: LALColors.bg,
      appBar: AppBar(
        title: Text(collection?.name ?? '...'),
        actions: [
          IconButton(
            tooltip: t.collectionAddPlace,
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => _addPlaces(context, ref),
          ),
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'rename') {
                _rename(context, ref, collection!);
              } else if (v == 'delete') {
                _delete(context, ref, collection!);
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(value: 'rename', child: Text(t.collectionRename)),
              PopupMenuItem(value: 'delete', child: Text(t.collectionDelete)),
            ],
          ),
        ],
      ),
      body: pinsAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(20),
          child: SkeletonList(itemCount: 4),
        ),
        error: (_, __) => EmptyView(
          icon: Icons.error_outline,
          title: t.errorGeneric,
          body: t.errorGenericBody,
        ),
        data: (pins) {
          if (pins.isEmpty) {
            return EmptyView(
              icon: Icons.bookmark_border_rounded,
              title: t.collectionEmpty,
              body: t.collectionEmptyBody,
              action: t.collectionAddPlace,
              onActionTap: () => _addPlaces(context, ref),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: pins.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) =>
                _CollectionPinTile(pin: pins[i], collectionId: collectionId),
          );
        },
      ),
    );
  }

  Future<void> _rename(
    BuildContext context,
    WidgetRef ref,
    SavedCollection c,
  ) async {
    if (ref.read(isOnlineProvider).valueOrNull == false) {
      LALToast.showOffline(context);
      return;
    }
    final name = await showDialog<String>(
      context: context,
      builder: (_) => _RenameCollectionDialog(initial: c.name),
    );
    if (name == null || name.isEmpty || name == c.name) return;
    try {
      await ref
          .read(savedNotifierProvider.notifier)
          .renameCollection(c.id, name);
    } on OfflineException {
      if (context.mounted) LALToast.showOffline(context);
    } catch (e) {
      if (context.mounted) LALToast.showError(context, e);
    }
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    SavedCollection c,
  ) async {
    final t = AppLocalizations.of(context)!;
    if (ref.read(isOnlineProvider).valueOrNull == false) {
      LALToast.showOffline(context);
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(t.collectionDeleteConfirmTitle),
        content: Text(t.collectionDeleteConfirmBody(c.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(t.buttonCancel),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: Text(t.collectionDelete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref.read(savedNotifierProvider.notifier).deleteCollection(c.id);
      if (context.mounted) {
        context.pop();
        LALToast.show(
          context,
          t.collectionDeleted,
          kind: LALToastKind.success,
        );
      }
    } on OfflineException {
      if (context.mounted) LALToast.showOffline(context);
    } catch (e) {
      if (context.mounted) LALToast.showError(context, e);
    }
  }

  Future<void> _addPlaces(BuildContext context, WidgetRef ref) async {
    if (ref.read(isOnlineProvider).valueOrNull == false) {
      LALToast.showOffline(context);
      return;
    }
    await showAddPlacesToCollectionSheet(
      context,
      ref,
      collectionId: collectionId,
    );
  }
}

class _CollectionPinTile extends ConsumerWidget {
  const _CollectionPinTile({required this.pin, required this.collectionId});

  final SavedPin pin;
  final String collectionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final placeAsync = ref.watch(placeDetailProvider(pin.placeId));
    final title = placeAsync.valueOrNull?.title ?? '...';
    final mediaUrl = placeAsync.valueOrNull?.mediaUrls.firstOrNull;
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
            ClipRRect(
              borderRadius: LALRadii.mdBorder,
              child: SizedBox(
                width: 60,
                height: 60,
                child: mediaUrl != null && mediaUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: mediaUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, __) =>
                            Container(color: LALColors.surfaceAlt),
                        errorWidget: (_, __, ___) => Container(
                          color: LALColors.surfaceAlt,
                          child: const Icon(
                            Icons.place_outlined,
                            color: LALColors.c300,
                            size: 28,
                          ),
                        ),
                      )
                    : Container(
                        color: LALColors.surfaceAlt,
                        child: const Icon(
                          Icons.place_outlined,
                          color: LALColors.c300,
                          size: 28,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: LALTypography.labelMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              tooltip: t.collectionRemoveFromCollection,
              icon: const Icon(
                Icons.remove_circle_outline,
                color: LALColors.c400,
                size: 20,
              ),
              onPressed: () async {
                if (ref.read(isOnlineProvider).valueOrNull == false) {
                  LALToast.showOffline(context);
                  return;
                }
                try {
                  await ref
                      .read(savedNotifierProvider.notifier)
                      .setPinCollection(pin.placeId, null);
                  if (context.mounted) {
                    LALToast.show(
                      context,
                      t.collectionRemovedFromCollection,
                      kind: LALToastKind.success,
                    );
                  }
                } on OfflineException {
                  if (context.mounted) LALToast.showOffline(context);
                } catch (e) {
                  if (context.mounted) LALToast.showError(context, e);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _RenameCollectionDialog extends StatefulWidget {
  const _RenameCollectionDialog({required this.initial});

  final String initial;

  @override
  State<_RenameCollectionDialog> createState() =>
      _RenameCollectionDialogState();
}

class _RenameCollectionDialogState extends State<_RenameCollectionDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initial);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.of(context).pop(_ctrl.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(t.collectionRenameTitle),
      content: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: TextFormField(
          controller: _ctrl,
          autofocus: true,
          textInputAction: TextInputAction.done,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(labelText: t.savedCollectionName),
          validator: LALValidators.compose([
            LALValidators.required(t),
            LALValidators.maxLength(t, 40),
          ]),
          onFieldSubmitted: (_) => _submit(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(t.buttonCancel),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text(t.collectionSave),
        ),
      ],
    );
  }
}
