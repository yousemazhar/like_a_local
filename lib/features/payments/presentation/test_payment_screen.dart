import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/connectivity_provider.dart';
import '../../../core/widgets/offline_action_snack_bar.dart';
import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';
import '../../auth/domain/auth_providers.dart';
import '../data/payment_repository.dart';

class TestPaymentScreen extends ConsumerStatefulWidget {
  const TestPaymentScreen({super.key});

  @override
  ConsumerState<TestPaymentScreen> createState() => _TestPaymentScreenState();
}

class _TestPaymentScreenState extends ConsumerState<TestPaymentScreen> {
  bool _busy = false;

  Future<void> _pay() async {
    if (ref.read(isOnlineProvider).valueOrNull == false) {
      showOfflineActionSnackBar(context);
      return;
    }
    // Confirm Firebase Auth has a current user before hitting the callable.
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not signed in — please sign in first.')),
      );
      return;
    }

    setState(() => _busy = true);
    try {
      // Force-refresh the token so the callable gets a fresh auth header.
      await firebaseUser.getIdToken(true);
      await ref.read(paymentRepositoryProvider).runTestCheckout();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Payment submitted — waiting on webhook to flip premium…',
          ),
        ),
      );
    } on StripeException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Stripe: ${e.error.localizedMessage ?? e.error.code}'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(authStateProvider);
    final userDocAsync = ref.watch(currentUserDocProvider);
    final premium = userDocAsync.valueOrNull?.premium ?? false;

    // Show sign-in prompt if auth is still loading or user is not signed in.
    return authAsync.when(
      loading: () => Scaffold(
        backgroundColor: LALColors.bg,
        appBar: AppBar(
          title: const Text('Test Payment'),
          backgroundColor: LALColors.surface,
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => Scaffold(
        backgroundColor: LALColors.bg,
        appBar: AppBar(
          title: const Text('Test Payment'),
          backgroundColor: LALColors.surface,
        ),
        body: const Center(child: Text('Auth error')),
      ),
      data: (user) {
        if (user == null) {
          return Scaffold(
            backgroundColor: LALColors.bg,
            appBar: AppBar(
              title: const Text('Test Payment'),
              backgroundColor: LALColors.surface,
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.lock_outline,
                      size: 48,
                      color: LALColors.c300,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'You need to sign in first.',
                      style: LALTypography.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: LALColors.accent,
                      ),
                      onPressed: () => context.go('/auth/sign-in'),
                      child: const Text('Sign In'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: LALColors.bg,
          appBar: AppBar(
            title: const Text('Test Payment'),
            backgroundColor: LALColors.surface,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: LALColors.surface,
                    borderRadius: LALRadii.lgBorder,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        premium
                            ? Icons.workspace_premium_rounded
                            : Icons.lock_outline,
                        color: premium ? LALColors.accent : LALColors.c400,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              premium ? 'Premium: ON ✓' : 'Premium: OFF',
                              style: LALTypography.labelLarge,
                            ),
                            Text(
                              'users/${user.uid} → .premium',
                              style: LALTypography.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: const BoxDecoration(
                    color: LALColors.surface,
                    borderRadius: LALRadii.lgBorder,
                  ),
                  child: Text(
                    'Signed in as: ${user.email}',
                    style: LALTypography.bodySmall.copyWith(
                      color: LALColors.c500,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Test card: 4242 4242 4242 4242\nAny future date · Any CVC',
                  style: LALTypography.bodySmall,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: LALColors.accent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _busy ? null : _pay,
                  child: _busy
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Pay €1.00 (test)'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
