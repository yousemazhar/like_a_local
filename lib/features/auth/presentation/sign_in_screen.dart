import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LALColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              _LALLogoHero(),
              const SizedBox(height: 40),
              Text('Welcome\nback.', style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: 8),
              const Text(
                'Sign in to discover your next local gem.',
                style: LALTypography.bodyMedium,
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _password,
                obscureText: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _signIn(),
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Forgot password?'),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _loading ? null : _signIn,
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Sign in'),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? ",
                      style: LALTypography.bodySmall),
                  GestureDetector(
                    onTap: () => context.go('/auth/sign-up'),
                    child: Text(
                      'Sign up',
                      style: LALTypography.labelMedium
                          .copyWith(color: LALColors.accent),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signIn() async {
    setState(() => _loading = true);
    // TODO: FirebaseAuth.instance.signInWithEmailAndPassword(...)
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() => _loading = false);
      context.go('/discover');
    }
  }
}

class _LALLogoHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 40,
          height: 40,
          child: Stack(
            children: [
              Center(
                child: Transform.rotate(
                  angle: 0.7854,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: LALColors.c900,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: LALColors.accent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'LikeALocal',
          style: LALTypography.headlineSmall.copyWith(fontSize: 20),
        ),
      ],
    );
  }
}
