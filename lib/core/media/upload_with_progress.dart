import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

typedef UploadProgressCallback = void Function(double progress, String label);

Future<String> uploadWithProgress({
  required Reference ref,
  required File file,
  required SettableMetadata metadata,
  required String label,
  required UploadProgressCallback onProgress,
}) async {
  final task = ref.putFile(file, metadata);
  onProgress(0, label);
  final sub = task.snapshotEvents.listen((snap) {
    final total = snap.totalBytes;
    if (total > 0) {
      onProgress(snap.bytesTransferred / total, label);
    }
  });
  try {
    await task;
  } finally {
    await sub.cancel();
  }
  return ref.getDownloadURL();
}

String videoExt(String path) {
  final dot = path.lastIndexOf('.');
  if (dot < 0 || dot == path.length - 1) return 'mp4';
  final ext = path.substring(dot + 1).toLowerCase();
  const allowed = {'mp4', 'mov', 'm4v', 'webm', '3gp'};
  return allowed.contains(ext) ? ext : 'mp4';
}

String videoMime(String ext) {
  switch (ext) {
    case 'mov':
    case 'm4v':
      return 'video/quicktime';
    case 'webm':
      return 'video/webm';
    case '3gp':
      return 'video/3gpp';
    default:
      return 'video/mp4';
  }
}
