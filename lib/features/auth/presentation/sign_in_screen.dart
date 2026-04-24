import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';
import '../data/auth_repository.dart';
import '../domain/auth_providers.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: LALColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              const _LALLogoHero(),
              const SizedBox(height: 40),
              Text(t.authWelcomeBack,
                  style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: 8),
              Text(
                t.authWelcomeSubtitle,
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
                onSubmitted: (_) => _signIn(),
                decoration: InputDecoration(labelText: t.authPassword),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _showForgotPassword(context),
                  child: Text(t.authForgotPassword),
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
                    : Text(t.authSignInButton),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(t.authNoAccount,
                      style: LALTypography.bodySmall),
                  GestureDetector(
                    onTap: () => context.go('/auth/sign-up'),
                    child: Text(
                      t.authSignUpLink,
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
    final t = AppLocalizations.of(context)!;
    if (_email.text.trim().isEmpty || _password.text.isEmpty) {
      setState(() => _error = t.authEnterEmailPassword);
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref
          .read(authRepositoryProvider)
          .signIn(_email.text, _password.text);
      if (mounted) context.go('/discover');
    } catch (e) {
      if (mounted) {
        setState(
            () => _error = AuthRepository.friendlyAuthError(e, context));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showForgotPassword(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final emailCtrl = TextEditingController(text: _email.text.trim());
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(t.authResetPasswordTitle),
        content: TextField(
          controller: emailCtrl,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(labelText: t.authEmail),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t.buttonCancel),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref
                    .read(authRepositoryProvider)
                    .sendPasswordResetEmail(emailCtrl.text);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(t.authResetSent)),
                  );
                }
              } catch (_) {}
            },
            child: Text(t.authResetSend),
          ),
        ],
      ),
    );
  }
}

class _LALLogoHero extends StatelessWidget {
  const _LALLogoHero();

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
