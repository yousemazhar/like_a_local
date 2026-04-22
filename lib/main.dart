import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: After running `flutterfire configure`, uncomment:
  // import 'package:firebase_core/firebase_core.dart';
  // import 'core/firebase/firebase_options.dart';
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  runApp(const ProviderScope(child: App()));
}
