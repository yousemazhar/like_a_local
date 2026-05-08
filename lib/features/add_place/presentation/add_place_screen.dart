import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/widgets/lal_chip.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';
import '../../auth/domain/auth_providers.dart';
import '../../place/domain/place.dart';

class _Draft {
  final List<XFile> photos = [];
  final titleCtrl = TextEditingController();
  final neighborhoodCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  String category = '';
  final tipCtrls = <TextEditingController>[TextEditingController()];
  final dishCtrls = <TextEditingController>[TextEditingController()];

  void dispose() {
    titleCtrl.dispose();
    neighborhoodCtrl.dispose();
    descriptionCtrl.dispose();
    for (final c in tipCtrls) {
      c.dispose();
    }
    for (final c in dishCtrls) {
      c.dispose();
    }
  }
}

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  int _step = 0;
  final _pageController = PageController();
  final _draft = _Draft();
  bool _publishing = false;

  @override
  void dispose() {
    _pageController.dispose();
    _draft.dispose();
    super.dispose();
  }

  void _next() {
    final t = AppLocalizations.of(context)!;
    if (_step == 0 && _draft.photos.isEmpty) {
      _snack(t.addPlacePhotosHint);
      return;
    }
    if (_step == 1) {
      if (_draft.titleCtrl.text.trim().length < 3) {
        _snack(t.addPlaceName);
        return;
      }
      if (_draft.category.isEmpty) {
        _snack(t.addPlaceCategory);
        return;
      }
    }
    final steps = _buildSteps(t);
    if (_step < steps.length - 1) {
      setState(() => _step++);
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut);
    }
  }

  void _back() {
    if (_step > 0) {
      setState(() => _step--);
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut);
    } else {
      context.pop();
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      imageQuality: 82,
    );
    if (picked != null) {
      setState(() => _draft.photos.add(picked));
    }
  }

  Future<({double? lat, double? lng})> _currentPosition() async {
    try {
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.deniedForever ||
          perm == LocationPermission.denied) {
        return (lat: null, lng: null);
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.medium),
      );
      return (lat: pos.latitude, lng: pos.longitude);
    } catch (_) {
      return (lat: null, lng: null);
    }
  }

  Future<List<String>> _uploadPhotos(String placeId) async {
    final urls = <String>[];
    final storage = FirebaseStorage.instance;
    for (var i = 0; i < _draft.photos.length; i++) {
      final file = File(_draft.photos[i].path);
      final ref = storage.ref('places/$placeId/photo_$i.jpg');
      await ref.putFile(
        file,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      urls.add(await ref.getDownloadURL());
    }
    return urls;
  }

  Future<void> _publish() async {
    final t = AppLocalizations.of(context)!;
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) {
      _snack(t.authErrorSignInFailed);
      return;
    }
    setState(() => _publishing = true);
    try {
      final pos = await _currentPosition();
      // Reserve a place id by creating a doc shell, then upload media to that id.
      final placeId = FirebaseFirestore.instance.collection('places').doc().id;
      final urls = await _uploadPhotos(placeId);
      final tips = <PlaceTip>[];
      for (var i = 0; i < _draft.tipCtrls.length; i++) {
        final txt = _draft.tipCtrls[i].text.trim();
        if (txt.isNotEmpty) tips.add(PlaceTip(text: txt, order: i));
      }
      final place = Place(
        id: placeId,
        title: _draft.titleCtrl.text.trim(),
        description: _draft.descriptionCtrl.text.trim(),
        category: _draft.category,
        neighborhood: _draft.neighborhoodCtrl.text.trim(),
        lat: pos.lat ?? 0,
        lng: pos.lng ?? 0,
        tips: tips,
        mediaUrls: urls,
        ownerUid: user.uid,
        ownerDisplayName: user.displayName ?? user.email.split('@').first,
      );
      // Use an explicit doc write so the id stays stable.
      await FirebaseFirestore.instance
          .collection('places')
          .doc(placeId)
          .set({
        ...place.toJson(),
        'id': placeId,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'saveCount': 0,
        'ratingAvg': 0.0,
        'ratingCount': 0,
        'hidden': false,
      });
      // Touch counter on user
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'counters': {
          'placesPosted': FieldValue.increment(1),
        },
      }, SetOptions(merge: true));
      if (!mounted) return;
      _snack(t.addPlaceReadyTitle);
      context.pop();
    } catch (e) {
      if (!mounted) return;
      _snack('$e');
    } finally {
      if (mounted) setState(() => _publishing = false);
    }
  }

  List<String> _buildSteps(AppLocalizations t) => [
        t.addPlacePhotos,
        t.addPlaceBasics,
        t.addPlaceTips,
        t.addPlacePreview,
      ];

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final steps = _buildSteps(t);

    return Scaffold(
      backgroundColor: LALColors.bg,
      appBar: AppBar(
        title: Text(steps[_step]),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: _back,
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(t.buttonCancel),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Row(
              children: [
                for (var i = 0; i < steps.length; i++) ...[
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 3,
                      decoration: BoxDecoration(
                        color: i <= _step ? LALColors.c900 : LALColors.c100,
                        borderRadius: LALRadii.pillBorder,
                      ),
                    ),
                  ),
                  if (i < steps.length - 1) const SizedBox(width: 6),
                ],
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _PhotosStep(draft: _draft, onPick: _pickPhoto, onRemove: (i) {
                  setState(() => _draft.photos.removeAt(i));
                }),
                _BasicsStep(
                  draft: _draft,
                  onCategory: (c) => setState(() => _draft.category = c),
                ),
                _TipsStep(
                  draft: _draft,
                  onAddTip: () => setState(
                      () => _draft.tipCtrls.add(TextEditingController())),
                  onAddDish: () => setState(
                      () => _draft.dishCtrls.add(TextEditingController())),
                ),
                _PreviewStep(draft: _draft),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
                20, 12, 20, 12 + MediaQuery.of(context).padding.bottom),
            decoration: const BoxDecoration(
              color: LALColors.surface,
              border: Border(top: BorderSide(color: LALColors.c100)),
            ),
            child: ElevatedButton(
              onPressed: _publishing
                  ? null
                  : (_step < steps.length - 1 ? _next : _publish),
              child: _publishing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : Text(_step < steps.length - 1
                      ? t.addPlaceNext(steps[_step + 1])
                      : t.addPlacePublish),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotosStep extends StatelessWidget {
  const _PhotosStep({
    required this.draft,
    required this.onPick,
    required this.onRemove,
  });

  final _Draft draft;
  final VoidCallback onPick;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.addPlacePhotosTitle,
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 6),
          Text(t.addPlacePhotosHint, style: LALTypography.bodySmall),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [
              for (var i = 0; i < draft.photos.length; i++)
                Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: LALRadii.lgBorder,
                      child: Image.file(File(draft.photos[i].path),
                          fit: BoxFit.cover),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => onRemove(i),
                        child: const CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.black54,
                          child: Icon(Icons.close,
                              size: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              GestureDetector(
                onTap: onPick,
                child: Container(
                  decoration: BoxDecoration(
                    color: LALColors.surfaceAlt,
                    borderRadius: LALRadii.lgBorder,
                    border: Border.all(color: LALColors.c200, width: 1.5),
                  ),
                  child: const Center(
                    child: Icon(Icons.add_a_photo_outlined,
                        color: LALColors.c500, size: 24),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BasicsStep extends StatelessWidget {
  const _BasicsStep({required this.draft, required this.onCategory});
  final _Draft draft;
  final ValueChanged<String> onCategory;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final categories = [
      t.categoryRestaurant,
      t.categoryCafe,
      t.categoryBar,
      t.categoryMarket,
      t.categoryViewpoint,
      t.categoryMuseum,
    ];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.addPlaceDetailsTitle,
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 20),
          TextField(
            controller: draft.titleCtrl,
            decoration: InputDecoration(labelText: t.addPlaceName),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: draft.neighborhoodCtrl,
            decoration: InputDecoration(labelText: t.addPlaceNeighborhood),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: draft.descriptionCtrl,
            decoration: InputDecoration(labelText: t.addPlaceDescription),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          Text(t.addPlaceCategory, style: LALTypography.labelMedium),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final c in categories)
                LALChip(
                  label: c,
                  isSelected: draft.category == c,
                  onTap: () => onCategory(c),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TipsStep extends StatelessWidget {
  const _TipsStep({
    required this.draft,
    required this.onAddTip,
    required this.onAddDish,
  });
  final _Draft draft;
  final VoidCallback onAddTip;
  final VoidCallback onAddDish;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.addPlaceTips,
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 6),
          Text(t.addPlaceTipsSubtitle, style: LALTypography.bodySmall),
          const SizedBox(height: 20),
          for (var i = 0; i < draft.tipCtrls.length; i++) ...[
            TextField(
              controller: draft.tipCtrls[i],
              decoration: InputDecoration(
                labelText: t.addPlaceTipLabel,
                hintText: t.addPlaceTipHint,
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 8),
          ],
          if (draft.tipCtrls.length < 5)
            TextButton.icon(
              onPressed: onAddTip,
              icon: const Icon(Icons.add, size: 16),
              label: Text(t.addPlaceAddTip),
            ),
          const Divider(height: 32),
          Text(t.placeDishes, style: LALTypography.labelLarge),
          const SizedBox(height: 12),
          for (var i = 0; i < draft.dishCtrls.length; i++) ...[
            TextField(
              controller: draft.dishCtrls[i],
              decoration: InputDecoration(labelText: t.addPlaceDishName),
            ),
            const SizedBox(height: 8),
          ],
          TextButton.icon(
            onPressed: onAddDish,
            icon: const Icon(Icons.add, size: 16),
            label: Text(t.addPlaceAddDish),
          ),
        ],
      ),
    );
  }
}

class _PreviewStep extends StatelessWidget {
  const _PreviewStep({required this.draft});
  final _Draft draft;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (draft.photos.isNotEmpty)
            ClipRRect(
              borderRadius: LALRadii.lgBorder,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.file(File(draft.photos.first.path),
                    fit: BoxFit.cover),
              ),
            ),
          const SizedBox(height: 16),
          Text(
            draft.titleCtrl.text.trim().isEmpty
                ? t.addPlaceName
                : draft.titleCtrl.text.trim(),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 4),
          Text(
            [
              if (draft.category.isNotEmpty) draft.category,
              if (draft.neighborhoodCtrl.text.trim().isNotEmpty)
                draft.neighborhoodCtrl.text.trim(),
            ].join(' · '),
            style: LALTypography.bodySmall,
          ),
          const SizedBox(height: 12),
          Text(draft.descriptionCtrl.text.trim(),
              style: LALTypography.bodyMedium),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: LALColors.accentSoft,
              borderRadius: LALRadii.lgBorder,
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle_outline_rounded,
                    color: LALColors.accent),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(t.addPlaceReadyBody,
                      style: LALTypography.bodySmall),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
