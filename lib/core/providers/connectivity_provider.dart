import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_provider.g.dart';

@Riverpod(keepAlive: true)
Stream<bool> isOnline(IsOnlineRef ref) async* {
  final connectivity = Connectivity();
  var last = !(await connectivity.checkConnectivity()).contains(
    ConnectivityResult.none,
  );
  yield last;

  await for (final results in connectivity.onConnectivityChanged) {
    final next = !results.contains(ConnectivityResult.none);
    if (next == last) continue;
    last = next;
    yield next;
  }
}
