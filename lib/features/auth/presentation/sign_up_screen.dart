import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LALColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 20, color: LALColors.c900),
          onPressed: () => context.go('/auth/sign-in'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text('Create\naccount.', style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: 8),
              const Text(
                'Join a community of locals sharing hidden gems.',
                style: LALTypography.bodyMedium,
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _name,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
              const SizedBox(height: 16),
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
                onSubmitted: (_) => _signUp(),
                decoration: const InputDecoration(
                  labelText: 'Password',
                  helperText: 'At least 8 characters',
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _loading ? null : _signUp,
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Create account'),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account? ',
                      style: LALTypography.bodySmall),
                  GestureDetector(
                    onTap: () => context.go('/auth/sign-in'),
                    child: Text(
                      'Sign in',
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

  Future<void> _signUp() async {
    setState(() => _loading = true);
    // TODO: FirebaseAuth.instance.createUserWithEmailAndPassword(...)
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() => _loading = false);
      context.go('/discover');
    }
  }
}
