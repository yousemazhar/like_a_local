import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'payment_repository.g.dart';

@Riverpod(keepAlive: true)
PaymentRepository paymentRepository(PaymentRepositoryRef ref) =>
    PaymentRepository(FirebaseFunctions.instance);

class PaymentRepository {
  PaymentRepository(this._functions);

  final FirebaseFunctions _functions;

  /// Runs the test checkout end-to-end:
  /// 1. Cloud Function creates a Stripe PaymentIntent + Ephemeral Key.
  /// 2. Client presents the Stripe PaymentSheet.
  /// 3. On success, Stripe → webhook → Firestore flips users/{uid}.premium.
  ///
  /// [plan] selects pricing ('monthly' = €4.99, 'yearly' = €35.88).
  /// Throws [StripeException] if the user cancels or the card is declined.
  Future<void> runTestCheckout({String plan = 'monthly'}) async {
    final callable = _functions.httpsCallable('createPaymentIntent');
    final result = await callable.call<Map<Object?, Object?>>({'plan': plan});
    final data = Map<String, dynamic>.from(result.data);

    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret:
            data['paymentIntentClientSecret'] as String,
        customerEphemeralKeySecret: data['ephemeralKeySecret'] as String,
        customerId: data['customerId'] as String,
        merchantDisplayName: 'Like a Local (test)',
        style: ThemeMode.light,
      ),
    );

    await Stripe.instance.presentPaymentSheet();
  }
}
