import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';
import '../data/auth_repository.dart';
import '../domain/auth_providers.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
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
              Text(t.authCreateAccount,
                  style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: 8),
              Text(
                t.authCreateSubtitle,
                style: LALTypography.bodyMedium,
              ),
              const SizedBox(height: 40),
              if (_error != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: LALColors.error.withValues(alpha: 0.1),
                    borderRadius: LALRadii.mdBorder,
                  ),
                  child: Text(_error!,
                      style: LALTypography.bodySmall
                          .copyWith(color: LALColors.error)),
                ),
                const SizedBox(height: 16),
              ],
              TextField(
                controller: _name,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: t.authName),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: t.authEmail),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _password,
                obscureText: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _signUp(),
                decoration: InputDecoration(
                  labelText: t.authPassword,
                  helperText: t.authPasswordHelper,
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
                    : Text(t.authCreateAccountButton),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(t.authHaveAccount,
                      style: LALTypography.bodySmall),
                  GestureDetector(
                    onTap: () => context.go('/auth/sign-in'),
                    child: Text(
                      t.authSignInLink,
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
    final t = AppLocalizations.of(context)!;
    if (_name.text.trim().isEmpty) {
      setState(() => _error = t.authEnterName);
      return;
    }
    if (_email.text.trim().isEmpty) {
      setState(() => _error = t.authEnterEmail);
      return;
    }
    if (_password.text.length < 6) {
      setState(() => _error = t.authPasswordMinLength);
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await ref
          .read(authRepositoryProvider)
          .signUp(_email.text, _password.text, _name.text);
      if (mounted) context.go('/onboarding');
    } catch (e) {
      if (mounted) {
        setState(
            () => _error = AuthRepository.friendlyAuthError(e, context));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
