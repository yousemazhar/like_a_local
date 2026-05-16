import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/errors/offline_exception.dart';
import '../../../core/media/upload_with_progress.dart';
import '../../../core/widgets/lal_toast.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';
import '../domain/review.dart';
import '../domain/review_providers.dart';

class ReviewComposerSheet extends ConsumerStatefulWidget {
  const ReviewComposerSheet({super.key, required this.placeId, this.existing});

  final String placeId;
  final Review? existing;

  static Future<void> show(
    BuildContext context, {
    required String placeId,
    Review? existing,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ReviewComposerSheet(placeId: placeId, existing: existing),
    );
  }

  @override
  ConsumerState<ReviewComposerSheet> createState() =>
      _ReviewComposerSheetState();
}

class _ReviewComposerSheetState extends ConsumerState<ReviewComposerSheet> {
  late final TextEditingController _controller;
  late int _rating;
  bool _submitting = false;
  bool _textEmpty = true;

  final List<String> _existingPhotoUrls = [];
  final List<String> _existingVideoUrls = [];
  final List<XFile> _newPhotos = [];
  final List<XFile> _newVideos = [];
  double? _uploadProgress;
  String? _uploadLabel;

  @override
  void initState() {
    super.initState();
    _rating = widget.existing?.rating ?? 5;
    _controller = TextEditingController(text: widget.existing?.text ?? '');
    _textEmpty = _controller.text.trim().isEmpty;
    _controller.addListener(() {
      final isEmpty = _controller.text.trim().isEmpty;
      if (isEmpty != _textEmpty) {
        setState(() => _textEmpty = isEmpty);
      }
    });
    if (widget.existing != null) {
      _existingPhotoUrls.addAll(widget.existing!.photoUrls);
      _existingVideoUrls.addAll(widget.existing!.videoUrls);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      imageQuality: 82,
    );
    if (picked != null && mounted) {
      setState(() => _newPhotos.add(picked));
    }
  }

  Future<void> _pickVideo() async {
    final picked = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(seconds: 60),
    );
    if (picked != null && mounted) {
      setState(() => _newVideos.add(picked));
    }
  }

  Future<void> _showAddMediaSheet() async {
    final t = AppLocalizations.of(context)!;
    final choice = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: LALColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: LALRadii.lg),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: LALColors.c200,
                borderRadius: LALRadii.pillBorder,
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading:
                  const Icon(Icons.photo_outlined, color: LALColors.c700),
              title: Text(t.addPlacePickPhoto),
              onTap: () => Navigator.of(ctx).pop('photo'),
            ),
            ListTile(
              leading:
                  const Icon(Icons.videocam_outlined, color: LALColors.c700),
              title: Text(t.addPlacePickVideo),
              onTap: () => Navigator.of(ctx).pop('video'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (choice == 'photo') {
      await _pickPhoto();
    } else if (choice == 'video') {
      await _pickVideo();
    }
  }

  void _onProgress(double p, String label) {
    if (mounted) {
      setState(() {
        _uploadProgress = p;
        _uploadLabel = label;
      });
    }
  }

  Future<List<String>> _uploadNewPhotos(String reviewId) async {
    final urls = <String>[];
    final storage = FirebaseStorage.instance;
    final baseIndex = _existingPhotoUrls.length;
    final total = _newPhotos.length;
    for (var i = 0; i < total; i++) {
      final file = File(_newPhotos[i].path);
      final ts = DateTime.now().millisecondsSinceEpoch;
      final ref = storage.ref(
        'places/${widget.placeId}/reviews/$reviewId/photo_${baseIndex + i}_$ts.jpg',
      );
      urls.add(await uploadWithProgress(
        ref: ref,
        file: file,
        metadata: SettableMetadata(contentType: 'image/jpeg'),
        label: 'Photo ${i + 1}/$total',
        onProgress: _onProgress,
      ));
    }
    return urls;
  }

  Future<List<String>> _uploadNewVideos(String reviewId) async {
    final urls = <String>[];
    final storage = FirebaseStorage.instance;
    final baseIndex = _existingVideoUrls.length;
    final total = _newVideos.length;
    for (var i = 0; i < total; i++) {
      final xfile = _newVideos[i];
      final file = File(xfile.path);
      final ts = DateTime.now().millisecondsSinceEpoch;
      final ext = videoExt(xfile.path);
      final ref = storage.ref(
        'places/${widget.placeId}/reviews/$reviewId/video_${baseIndex + i}_$ts.$ext',
      );
      urls.add(await uploadWithProgress(
        ref: ref,
        file: file,
        metadata: SettableMetadata(contentType: videoMime(ext)),
        label: 'Video ${i + 1}/$total',
        onProgress: _onProgress,
      ));
    }
    return urls;
  }

  Future<void> _submit() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() => _textEmpty = true);
      return;
    }
    setState(() {
      _submitting = true;
      _uploadProgress = null;
      _uploadLabel = null;
    });
    try {
      final reviewId = widget.existing?.id ??
          ref.read(reviewRepositoryProvider).reservedReviewId(widget.placeId);
      final newPhotoUrls = await _uploadNewPhotos(reviewId);
      final newVideoUrls = await _uploadNewVideos(reviewId);
      await ref.read(reviewNotifierProvider.notifier).submit(
            placeId: widget.placeId,
            rating: _rating,
            text: text,
            photoUrls: [..._existingPhotoUrls, ...newPhotoUrls],
            videoUrls: [..._existingVideoUrls, ...newVideoUrls],
            reviewId: widget.existing == null ? reviewId : null,
          );
      if (mounted) Navigator.of(context).pop();
    } on OfflineException {
      if (mounted) LALToast.showOffline(context);
    } catch (e) {
      if (mounted) LALToast.show(context, '$e');
    } finally {
      if (mounted) {
        setState(() {
          _submitting = false;
          _uploadProgress = null;
          _uploadLabel = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final inset = MediaQuery.of(context).viewInsets.bottom;
    final hasMedia = _existingPhotoUrls.isNotEmpty ||
        _existingVideoUrls.isNotEmpty ||
        _newPhotos.isNotEmpty ||
        _newVideos.isNotEmpty;
    return Padding(
      padding: EdgeInsets.only(bottom: inset),
      child: Container(
        decoration: const BoxDecoration(
          color: LALColors.surface,
          borderRadius: BorderRadius.vertical(top: LALRadii.xl),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: LALColors.c200,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                t.reviewComposerTitle,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(t.reviewComposerBody, style: LALTypography.bodySmall),
              const SizedBox(height: 16),
              Row(
                children: [
                  for (var i = 1; i <= 5; i++)
                    GestureDetector(
                      onTap: () => setState(() => _rating = i),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Icon(
                          i <= _rating
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: LALColors.accent,
                          size: 36,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 88,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (var i = 0; i < _existingPhotoUrls.length; i++)
                      _MediaThumb(
                        url: _existingPhotoUrls[i],
                        isVideo: false,
                        onRemove: _submitting
                            ? null
                            : () => setState(
                                  () => _existingPhotoUrls.removeAt(i),
                                ),
                      ),
                    for (var i = 0; i < _existingVideoUrls.length; i++)
                      _MediaThumb(
                        url: _existingVideoUrls[i],
                        isVideo: true,
                        onRemove: _submitting
                            ? null
                            : () => setState(
                                  () => _existingVideoUrls.removeAt(i),
                                ),
                      ),
                    for (var i = 0; i < _newPhotos.length; i++)
                      _MediaThumb(
                        file: File(_newPhotos[i].path),
                        isVideo: false,
                        onRemove: _submitting
                            ? null
                            : () => setState(() => _newPhotos.removeAt(i)),
                      ),
                    for (var i = 0; i < _newVideos.length; i++)
                      _MediaThumb(
                        file: File(_newVideos[i].path),
                        isVideo: true,
                        onRemove: _submitting
                            ? null
                            : () => setState(() => _newVideos.removeAt(i)),
                      ),
                    _AddMediaTile(
                      onTap: _submitting ? null : _showAddMediaSheet,
                    ),
                  ],
                ),
              ),
              if (hasMedia) const SizedBox(height: 12) else const SizedBox(height: 4),
              TextField(
                controller: _controller,
                maxLines: 5,
                maxLength: 500,
                decoration: InputDecoration(
                  hintText: '${t.reviewComposerHint} *',
                  errorText: _textEmpty ? t.reviewComposerTextRequired : null,
                  filled: true,
                  fillColor: LALColors.surfaceAlt,
                  border: OutlineInputBorder(
                    borderRadius: LALRadii.lgBorder,
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              if (_submitting && _uploadProgress != null) ...[
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _uploadLabel ?? 'Uploading…',
                        style: LALTypography.labelSmall,
                      ),
                    ),
                    Text(
                      '${(_uploadProgress! * 100).clamp(0, 100).toStringAsFixed(0)}%',
                      style: LALTypography.labelSmall,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: LALRadii.pillBorder,
                  child: LinearProgressIndicator(
                    value: _uploadProgress,
                    minHeight: 6,
                    backgroundColor: LALColors.c100,
                    valueColor:
                        const AlwaysStoppedAnimation(LALColors.accent),
                  ),
                ),
                const SizedBox(height: 10),
              ],
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_submitting || _textEmpty) ? null : _submit,
                  child: _submitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          widget.existing == null
                              ? t.reviewComposerSubmit
                              : t.reviewComposerUpdate,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MediaThumb extends StatelessWidget {
  const _MediaThumb({
    this.url,
    this.file,
    required this.isVideo,
    this.onRemove,
  }) : assert(url != null || file != null);

  final String? url;
  final File? file;
  final bool isVideo;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    Widget thumb;
    if (file != null && !isVideo) {
      thumb = Image.file(file!, fit: BoxFit.cover);
    } else if (url != null && !isVideo) {
      thumb = CachedNetworkImage(
        imageUrl: url!,
        fit: BoxFit.cover,
        placeholder: (_, __) => const ColoredBox(color: LALColors.c100),
        errorWidget: (_, __, ___) =>
            const ColoredBox(color: LALColors.c100),
      );
    } else {
      thumb = Container(
        color: LALColors.c900,
        alignment: Alignment.center,
        child: const Icon(
          Icons.play_circle_outline,
          color: Colors.white,
          size: 28,
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: LALRadii.mdBorder,
            child: SizedBox(width: 80, height: 80, child: thumb),
          ),
          if (onRemove != null)
            Positioned(
              top: 2,
              right: 2,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(2),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AddMediaTile extends StatelessWidget {
  const _AddMediaTile({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: LALColors.surfaceAlt,
          borderRadius: LALRadii.mdBorder,
          border: Border.all(color: LALColors.c200),
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.add_a_photo_outlined,
          color: LALColors.c700,
          size: 24,
        ),
      ),
    );
  }
}
