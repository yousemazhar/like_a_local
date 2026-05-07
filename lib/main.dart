import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'app.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  // Load secrets from .env (bundled as a Flutter asset).
  await dotenv.load(fileName: '.env');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // App Check disabled during payment integration testing.
  // Re-enable before shipping by uncommenting and registering the debug token
  // in Firebase Console → App Check → Apps → Android.

  final stripePk = dotenv.maybeGet('STRIPE_PK') ?? '';
  assert(
    stripePk.isNotEmpty,
    'STRIPE_PK is missing from .env at the project root.',
  );
  if (stripePk.isNotEmpty) {
    Stripe.publishableKey = stripePk;
    await Stripe.instance.applySettings();
  }

  runApp(const ProviderScope(child: App()));
}
