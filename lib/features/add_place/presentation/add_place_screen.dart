import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/providers/connectivity_provider.dart';
import '../../../core/widgets/offline_action_snack_bar.dart';
import '../../../core/widgets/lal_chip.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';
import '../../auth/domain/auth_providers.dart';
import '../../place/domain/place.dart';
import '../../place/domain/place_providers.dart';

class _Draft {
  final List<XFile> photos = [];
  final List<String> existingPhotoUrls = [];
  final titleCtrl = TextEditingController();
  final neighborhoodCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  String category = '';
  double? lat;
  double? lng;
  final tipCtrls = <TextEditingController>[TextEditingController()];
  final dishCtrls = <TextEditingController>[TextEditingController()];

  void dispose() {
    titleCtrl.dispose();
    neighborhoodCtrl.dispose();
    addressCtrl.dispose();
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
  const AddPlaceScreen({super.key, this.placeId});

  /// When non-null, the screen edits an existing place instead of creating one.
  final String? placeId;

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  int _step = 0;
  final _pageController = PageController();
  final _draft = _Draft();
  bool _publishing = false;
  bool _prefilled = false;

  bool get _isEdit => widget.placeId != null;

  @override
  void dispose() {
    _pageController.dispose();
    _draft.dispose();
    super.dispose();
  }

  void _prefill(Place p) {
    if (_prefilled) return;
    _prefilled = true;
    _draft.titleCtrl.text = p.title;
    _draft.neighborhoodCtrl.text = p.neighborhood;
    _draft.addressCtrl.text = p.address;
    _draft.descriptionCtrl.text = p.description;
    _draft.category = p.category;
    _draft.existingPhotoUrls.addAll(p.mediaUrls);
    if (p.lat != 0 || p.lng != 0) {
      _draft.lat = p.lat;
      _draft.lng = p.lng;
    }
    _draft.tipCtrls.clear();
    for (final t in p.tips) {
      _draft.tipCtrls.add(TextEditingController(text: t.text));
    }
    if (_draft.tipCtrls.isEmpty) {
      _draft.tipCtrls.add(TextEditingController());
    }
    // Dishes are not in Place model fields exposed today; skip prefill.
  }

  void _next() {
    final t = AppLocalizations.of(context)!;
    if (_step == 0 &&
        _draft.photos.isEmpty &&
        _draft.existingPhotoUrls.isEmpty) {
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
    if (_step == 2 && (_draft.lat == null || _draft.lng == null)) {
      _snack('Pick a location on the map');
      return;
    }
    final steps = _buildSteps(t);
    if (_step < steps.length - 1) {
      setState(() => _step++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _back() {
    if (_step > 0) {
      setState(() => _step--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
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
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );
      return (lat: pos.latitude, lng: pos.longitude);
    } catch (_) {
      return (lat: null, lng: null);
    }
  }

  Future<List<String>> _uploadNewPhotos(String placeId) async {
    final urls = <String>[];
    final storage = FirebaseStorage.instance;
    final baseIndex = _draft.existingPhotoUrls.length;
    for (var i = 0; i < _draft.photos.length; i++) {
      final file = File(_draft.photos[i].path);
      final ts = DateTime.now().millisecondsSinceEpoch;
      final ref = storage.ref('places/$placeId/photo_${baseIndex + i}_$ts.jpg');
      await ref.putFile(file, SettableMetadata(contentType: 'image/jpeg'));
      urls.add(await ref.getDownloadURL());
    }
    return urls;
  }

  Future<void> _publish() async {
    final t = AppLocalizations.of(context)!;
    if (ref.read(isOnlineProvider).valueOrNull == false) {
      showOfflineActionSnackBar(context);
      return;
    }
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) {
      _snack(t.authErrorSignInFailed);
      return;
    }
    setState(() => _publishing = true);
    try {
      final placeId = _isEdit
          ? widget.placeId!
          : FirebaseFirestore.instance.collection('places').doc().id;
      final newUrls = await _uploadNewPhotos(placeId);
      final allUrls = [..._draft.existingPhotoUrls, ...newUrls];
      final tips = <Map<String, dynamic>>[];
      for (var i = 0; i < _draft.tipCtrls.length; i++) {
        final txt = _draft.tipCtrls[i].text.trim();
        if (txt.isNotEmpty) tips.add({'text': txt, 'order': i});
      }
      final dishes = <Map<String, dynamic>>[];
      for (final c in _draft.dishCtrls) {
        final name = c.text.trim();
        if (name.isNotEmpty) dishes.add({'name': name});
      }

      final docRef = FirebaseFirestore.instance
          .collection('places')
          .doc(placeId);

      if (_isEdit) {
        await docRef.set({
          'title': _draft.titleCtrl.text.trim(),
          'description': _draft.descriptionCtrl.text.trim(),
          'category': _draft.category,
          'neighborhood': _draft.neighborhoodCtrl.text.trim(),
          'address': _draft.addressCtrl.text.trim(),
          if (_draft.lat != null) 'lat': _draft.lat,
          if (_draft.lng != null) 'lng': _draft.lng,
          'tips': tips,
          'dishes': dishes,
          'mediaUrls': allUrls,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } else {
        await docRef.set({
          'id': placeId,
          'title': _draft.titleCtrl.text.trim(),
          'description': _draft.descriptionCtrl.text.trim(),
          'category': _draft.category,
          'moods': const <String>[],
          'city': '',
          'neighborhood': _draft.neighborhoodCtrl.text.trim(),
          'address': _draft.addressCtrl.text.trim(),
          'lat': _draft.lat ?? 0,
          'lng': _draft.lng ?? 0,
          'tips': tips,
          'dishes': dishes,
          'mediaUrls': allUrls,
          'ownerUid': user.uid,
          'ownerIsSuper': false,
          'ratingAvg': 0.0,
          'ratingCount': 0,
          'saveCount': 0,
          'featured': false,
          'hidden': false,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'counters': {'placesPosted': FieldValue.increment(1)},
        }, SetOptions(merge: true));
      }
      if (!mounted) return;
      _snack(_isEdit ? 'Place updated' : t.addPlaceReadyTitle);
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
    'Location',
    t.addPlaceTips,
    t.addPlacePreview,
  ];

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final steps = _buildSteps(t);

    if (_isEdit && !_prefilled) {
      final placeAsync = ref.watch(placeDetailProvider(widget.placeId!));
      placeAsync.whenData((p) {
        if (p != null) {
          _prefill(p);
          // Trigger rebuild so the prefilled controllers show up.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() {});
          });
        }
      });
    }

    return Scaffold(
      backgroundColor: LALColors.bg,
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit · ${steps[_step]}' : steps[_step]),
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
                _PhotosStep(
                  draft: _draft,
                  onPick: _pickPhoto,
                  onRemoveNew: (i) => setState(() => _draft.photos.removeAt(i)),
                  onRemoveExisting: (i) =>
                      setState(() => _draft.existingPhotoUrls.removeAt(i)),
                ),
                _BasicsStep(
                  draft: _draft,
                  onCategory: (c) => setState(() => _draft.category = c),
                ),
                _LocationStep(
                  draft: _draft,
                  onChanged: (lat, lng) => setState(() {
                    _draft.lat = lat;
                    _draft.lng = lng;
                  }),
                  onUseCurrent: () async {
                    final pos = await _currentPosition();
                    if (pos.lat != null && pos.lng != null) {
                      setState(() {
                        _draft.lat = pos.lat;
                        _draft.lng = pos.lng;
                      });
                    } else if (mounted) {
                      _snack('Location permission denied');
                    }
                  },
                ),
                _TipsStep(
                  draft: _draft,
                  onAddTip: () => setState(
                    () => _draft.tipCtrls.add(TextEditingController()),
                  ),
                  onAddDish: () => setState(
                    () => _draft.dishCtrls.add(TextEditingController()),
                  ),
                ),
                _PreviewStep(draft: _draft),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
              20,
              12,
              20,
              12 + MediaQuery.of(context).padding.bottom,
            ),
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
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      _step < steps.length - 1
                          ? t.addPlaceNext(steps[_step + 1])
                          : (_isEdit ? 'Save changes' : t.addPlacePublish),
                    ),
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
    required this.onRemoveNew,
    required this.onRemoveExisting,
  });

  final _Draft draft;
  final VoidCallback onPick;
  final ValueChanged<int> onRemoveNew;
  final ValueChanged<int> onRemoveExisting;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.addPlacePhotosTitle,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
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
              for (var i = 0; i < draft.existingPhotoUrls.length; i++)
                Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: LALRadii.lgBorder,
                      child: CachedNetworkImage(
                        imageUrl: draft.existingPhotoUrls[i],
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => onRemoveExisting(i),
                        child: const CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.black54,
                          child: Icon(
                            Icons.close,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              for (var i = 0; i < draft.photos.length; i++)
                Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: LALRadii.lgBorder,
                      child: Image.file(
                        File(draft.photos[i].path),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => onRemoveNew(i),
                        child: const CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.black54,
                          child: Icon(
                            Icons.close,
                            size: 14,
                            color: Colors.white,
                          ),
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
                    child: Icon(
                      Icons.add_a_photo_outlined,
                      color: LALColors.c500,
                      size: 24,
                    ),
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
          Text(
            t.addPlaceDetailsTitle,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
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
            controller: draft.addressCtrl,
            decoration: const InputDecoration(labelText: 'Address'),
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

class _LocationStep extends StatefulWidget {
  const _LocationStep({
    required this.draft,
    required this.onChanged,
    required this.onUseCurrent,
  });

  final _Draft draft;
  final void Function(double lat, double lng) onChanged;
  final VoidCallback onUseCurrent;

  @override
  State<_LocationStep> createState() => _LocationStepState();
}

class _LocationStepState extends State<_LocationStep> {
  GoogleMapController? _controller;

  static const _fallback = LatLng(30.0444, 31.2357); // Cairo

  LatLng get _current {
    final lat = widget.draft.lat;
    final lng = widget.draft.lng;
    if (lat != null && lng != null) return LatLng(lat, lng);
    return _fallback;
  }

  @override
  void didUpdateWidget(covariant _LocationStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    final lat = widget.draft.lat;
    final lng = widget.draft.lng;
    if (lat != null && lng != null) {
      _controller?.animateCamera(CameraUpdate.newLatLng(LatLng(lat, lng)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasPin = widget.draft.lat != null && widget.draft.lng != null;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pin the location',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 6),
              Text(
                'Tap on the map to drop a pin, or use your current location.',
                style: LALTypography.bodySmall,
              ),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _current,
                  zoom: hasPin ? 15 : 11,
                ),
                onMapCreated: (c) => _controller = c,
                onTap: (pos) => widget.onChanged(pos.latitude, pos.longitude),
                markers: hasPin
                    ? {
                        Marker(
                          markerId: const MarkerId('selected'),
                          position: _current,
                          draggable: true,
                          onDragEnd: (pos) =>
                              widget.onChanged(pos.latitude, pos.longitude),
                        ),
                      }
                    : const {},
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
              ),
              Positioned(
                right: 12,
                bottom: 12,
                child: FloatingActionButton.small(
                  heroTag: 'use-current-loc',
                  onPressed: widget.onUseCurrent,
                  child: const Icon(Icons.my_location),
                ),
              ),
              if (hasPin)
                Positioned(
                  left: 12,
                  bottom: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: LALColors.surface,
                      borderRadius: LALRadii.pillBorder,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      '${widget.draft.lat!.toStringAsFixed(5)}, ${widget.draft.lng!.toStringAsFixed(5)}',
                      style: LALTypography.labelSmall,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
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
          Text(
            t.addPlaceTips,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
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
    Widget? hero;
    if (draft.photos.isNotEmpty) {
      hero = Image.file(File(draft.photos.first.path), fit: BoxFit.cover);
    } else if (draft.existingPhotoUrls.isNotEmpty) {
      hero = CachedNetworkImage(
        imageUrl: draft.existingPhotoUrls.first,
        fit: BoxFit.cover,
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hero != null)
            ClipRRect(
              borderRadius: LALRadii.lgBorder,
              child: AspectRatio(aspectRatio: 16 / 9, child: hero),
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
          if (draft.lat != null && draft.lng != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.place_outlined,
                  size: 14,
                  color: LALColors.c500,
                ),
                const SizedBox(width: 4),
                Text(
                  '${draft.lat!.toStringAsFixed(5)}, ${draft.lng!.toStringAsFixed(5)}',
                  style: LALTypography.bodySmall,
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          Text(
            draft.descriptionCtrl.text.trim(),
            style: LALTypography.bodyMedium,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: LALColors.accentSoft,
              borderRadius: LALRadii.lgBorder,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_outline_rounded,
                  color: LALColors.accent,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    t.addPlaceReadyBody,
                    style: LALTypography.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
