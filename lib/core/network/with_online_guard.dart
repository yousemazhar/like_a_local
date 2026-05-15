import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../errors/app_exception.dart';
import '../providers/connectivity_provider.dart';

/// Run [op] only if the device is currently online; otherwise throw
/// [AppException.network] immediately so the caller doesn't wait on Firebase
/// timeouts.
///
/// Reads `isOnlineProvider` once (no listen) — treat unknown state as online
/// so first-launch races don't block legitimate writes.
Future<T> withOnlineGuard<T>(
  Ref ref,
  Future<T> Function() op,
) async {
  final online = ref.read(isOnlineProvider).valueOrNull ?? true;
  if (!online) throw AppException.network();
  return op();
}

/// Variant for widgets that hold a `WidgetRef`.
Future<T> withOnlineGuardW<T>(
  WidgetRef ref,
  Future<T> Function() op,
) async {
  final online = ref.read(isOnlineProvider).valueOrNull ?? true;
  if (!online) throw AppException.network();
  return op();
}
