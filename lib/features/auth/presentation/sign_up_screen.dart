import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/forms/validators.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  bool _googleLoading = false;
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
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: LALColors.c900,
          ),
          onPressed: () => context.go('/auth/sign-in'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                t.authCreateAccount,
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 8),
              Text(t.authCreateSubtitle, style: LALTypography.bodyMedium),
              const SizedBox(height: 40),
              if (_error != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: LALColors.error.withValues(alpha: 0.1),
                    borderRadius: LALRadii.mdBorder,
                  ),
                  child: Text(
                    _error!,
                    style: LALTypography.bodySmall.copyWith(
                      color: LALColors.error,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              TextFormField(
                controller: _name,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.name],
                validator: LALValidators.required(t),
                decoration: InputDecoration(labelText: t.authName),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                validator: LALValidators.email(t),
                decoration: InputDecoration(labelText: t.authEmail),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _password,
                obscureText: true,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _signUp(),
                autofillHints: const [AutofillHints.newPassword],
                validator: LALValidators.minLength(t, 6),
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
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(t.authCreateAccountButton),
              ),
              const SizedBox(height: 16),
              const _OrDivider(),
              const SizedBox(height: 16),
              _GoogleSignInButton(
                loading: _googleLoading,
                label: t.authSignUpWithGoogle,
                onPressed: _signUpWithGoogle,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(t.authHaveAccount, style: LALTypography.bodySmall),
                  GestureDetector(
                    onTap: () => context.go('/auth/sign-in'),
                    child: Text(
                      t.authSignInLink,
                      style: LALTypography.labelMedium.copyWith(
                        color: LALColors.accent,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
        ),
      ),
    );
  }

  Future<void> _signUpWithGoogle() async {
    setState(() {
      _googleLoading = true;
      _error = null;
    });
    try {
      final user = await ref.read(authRepositoryProvider).signInWithGoogle();
      if (!mounted) return;
      // For Google sign-up, go to onboarding if new user, otherwise discover
      if (user != null) context.go('/onboarding');
    } catch (e) {
      if (mounted) {
        setState(() => _error = AuthRepository.friendlyAuthError(e, context));
      }
    } finally {
      if (mounted) setState(() => _googleLoading = false);
    }
  }

  Future<void> _signUp() async {
    final t = AppLocalizations.of(context)!;
    if (!(_formKey.currentState?.validate() ?? false)) {
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
          .signUp(_email.text, _password.text, _name.text);
      if (mounted) context.go('/onboarding');
    } catch (e) {
      if (mounted) {
        setState(() => _error = AuthRepository.friendlyAuthError(e, context));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: LALColors.c200)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'or',
            style: LALTypography.bodySmall.copyWith(color: LALColors.c400),
          ),
        ),
        const Expanded(child: Divider(color: LALColors.c200)),
      ],
    );
  }
}

class _GoogleSignInButton extends StatelessWidget {
  const _GoogleSignInButton({
    required this.loading,
    required this.label,
    required this.onPressed,
  });

  final bool loading;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: loading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: LALColors.c200),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.white,
        ),
        child: loading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: LALColors.c600,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CustomPaint(painter: _GoogleLogoPainter()),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    label,
                    style: LALTypography.labelMedium.copyWith(
                      color: LALColors.c900,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius - 1);
    const strokeWidth = 3.5;
    void drawArc(double start, double sweep, Color color) {
      canvas.drawArc(
        rect,
        start,
        sweep,
        false,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round,
      );
    }

    drawArc(-1.57, 1.57, const Color(0xFF4285F4));
    drawArc(0.0, 1.57, const Color(0xFF34A853));
    drawArc(1.57, 1.57, const Color(0xFFFBBC05));
    drawArc(3.14, 1.57, const Color(0xFFEA4335));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
