import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/offline_exception.dart';
import '../../../core/widgets/lal_toast.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';
import '../../place/domain/place_providers.dart';
import '../domain/saved_pin.dart';
import '../domain/saved_providers.dart';

/// Bottom sheet: pick a collection (or "no collection") to move a single
/// pinned place into.
Future<void> showMovePinToCollectionSheet(
  BuildContext context,
  WidgetRef ref, {
  required String placeId,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: LALColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: LALRadii.lg),
    ),
    builder: (sheetCtx) => _MovePinSheet(placeId: placeId, parentRef: ref),
  );
}

class _MovePinSheet extends ConsumerWidget {
  const _MovePinSheet({required this.placeId, required this.parentRef});

  final String placeId;
  // The parent ref keeps the sheet's mutations addressing the same providers
  // even though showModalBottomSheet builds in a fresh Navigator subtree.
  final WidgetRef parentRef;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final collectionsAsync = ref.watch(savedCollectionsProvider);
    final pinsAsync = ref.watch(savedPinsProvider);
    final currentPin = pinsAsync.valueOrNull
        ?.where((p) => p.placeId == placeId)
        .cast<SavedPin?>()
        .firstWhere((_) => true, orElse: () => null);
    final currentCollectionId = currentPin?.collectionId;
    final collections = collectionsAsync.valueOrNull ?? const <SavedCollection>[];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: Text(
                t.collectionMoveTo,
                style: LALTypography.headlineSmall,
              ),
            ),
            const Divider(height: 1),
            if (collectionsAsync.isLoading && collections.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              )
            else ...[
              _CollectionRow(
                name: t.collectionNone,
                selected: currentCollectionId == null,
                onTap: () async {
                  Navigator.pop(context);
                  await _move(context, parentRef, placeId, null, null);
                },
              ),
              for (final c in collections)
                _CollectionRow(
                  name: c.name,
                  selected: currentCollectionId == c.id,
                  onTap: () async {
                    Navigator.pop(context);
                    await _move(context, parentRef, placeId, c.id, c.name);
                  },
                ),
            ],
          ],
        ),
      ),
    );
  }
}

Future<void> _move(
  BuildContext context,
  WidgetRef ref,
  String placeId,
  String? collectionId,
  String? collectionName,
) async {
  final t = AppLocalizations.of(context)!;
  try {
    await ref
        .read(savedNotifierProvider.notifier)
        .setPinCollection(placeId, collectionId);
    if (!context.mounted) return;
    LALToast.show(
      context,
      collectionName == null
          ? t.collectionRemovedFromCollection
          : t.collectionMovedTo(collectionName),
      kind: LALToastKind.success,
    );
  } on OfflineException {
    if (context.mounted) LALToast.showOffline(context);
  } catch (e) {
    if (context.mounted) LALToast.showError(context, e);
  }
}

/// Bottom sheet: pick multiple already-saved places to bulk-add into a
/// specific collection.
Future<void> showAddPlacesToCollectionSheet(
  BuildContext context,
  WidgetRef ref, {
  required String collectionId,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: LALColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: LALRadii.lg),
    ),
    builder: (_) => _AddPlacesSheet(collectionId: collectionId),
  );
}

class _AddPlacesSheet extends ConsumerStatefulWidget {
  const _AddPlacesSheet({required this.collectionId});

  final String collectionId;

  @override
  ConsumerState<_AddPlacesSheet> createState() => _AddPlacesSheetState();
}

class _AddPlacesSheetState extends ConsumerState<_AddPlacesSheet> {
  final _selected = <String>{};
  bool _busy = false;

  Future<void> _submit() async {
    if (_selected.isEmpty) {
      Navigator.pop(context);
      return;
    }
    final t = AppLocalizations.of(context)!;
    final collection = ref
        .read(savedCollectionsProvider)
        .valueOrNull
        ?.where((c) => c.id == widget.collectionId)
        .cast<SavedCollection?>()
        .firstWhere((_) => true, orElse: () => null);
    setState(() => _busy = true);
    try {
      final notifier = ref.read(savedNotifierProvider.notifier);
      for (final placeId in _selected) {
        await notifier.setPinCollection(placeId, widget.collectionId);
      }
      if (!mounted) return;
      Navigator.pop(context);
      LALToast.show(
        context,
        t.collectionAddedToPlural(
          _selected.length,
          collection?.name ?? '',
        ),
        kind: LALToastKind.success,
      );
    } on OfflineException {
      if (mounted) LALToast.showOffline(context);
    } catch (e) {
      if (mounted) LALToast.showError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final pinsAsync = ref.watch(savedPinsProvider);
    // Only show pins NOT already in this collection.
    final pins = (pinsAsync.valueOrNull ?? [])
        .where((p) => p.collectionId != widget.collectionId)
        .toList(growable: false);

    final mq = MediaQuery.of(context);
    final maxHeight = mq.size.height * 0.75;

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Padding(
          padding: EdgeInsets.only(bottom: mq.viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        t.collectionPickPlaces,
                        style: LALTypography.headlineSmall,
                      ),
                    ),
                    TextButton(
                      onPressed: _busy ? null : _submit,
                      child: Text(t.collectionAdd),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: pins.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text(
                            t.collectionNoSavedPlaces,
                            style: LALTypography.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: pins.length,
                        itemBuilder: (_, i) {
                          final pin = pins[i];
                          return _PinPickRow(
                            placeId: pin.placeId,
                            selected: _selected.contains(pin.placeId),
                            onChanged: (v) {
                              setState(() {
                                if (v == true) {
                                  _selected.add(pin.placeId);
                                } else {
                                  _selected.remove(pin.placeId);
                                }
                              });
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PinPickRow extends ConsumerWidget {
  const _PinPickRow({
    required this.placeId,
    required this.selected,
    required this.onChanged,
  });

  final String placeId;
  final bool selected;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = ref.watch(placeDetailProvider(placeId)).valueOrNull?.title ??
        '...';
    return CheckboxListTile(
      value: selected,
      onChanged: onChanged,
      title: Text(title, style: LALTypography.labelMedium),
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: LALColors.accent,
    );
  }
}

class _CollectionRow extends StatelessWidget {
  const _CollectionRow({
    required this.name,
    required this.selected,
    required this.onTap,
  });

  final String name;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        selected
            ? Icons.radio_button_checked
            : Icons.collections_bookmark_outlined,
        color: selected ? LALColors.accent : LALColors.c500,
      ),
      title: Text(name, style: LALTypography.labelMedium),
      trailing: selected
          ? const Icon(Icons.check, color: LALColors.accent, size: 18)
          : null,
    );
  }
}
