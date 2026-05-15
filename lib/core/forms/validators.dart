import '../../l10n/app_localizations.dart';

/// Reusable, localized form-field validators for use with `TextFormField`.
///
/// Each builder returns a `FormFieldValidator<String>` (i.e. `String? Function(String?)`).
class LALValidators {
  LALValidators._();

  static String? Function(String?) required(AppLocalizations t) {
    return (value) {
      if (value == null || value.trim().isEmpty) return t.validatorRequired;
      return null;
    };
  }

  static String? Function(String?) email(AppLocalizations t,
      {bool optional = false}) {
    final pattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return (value) {
      final v = value?.trim() ?? '';
      if (v.isEmpty) return optional ? null : t.validatorRequired;
      if (!pattern.hasMatch(v)) return t.validatorEmail;
      return null;
    };
  }

  static String? Function(String?) minLength(AppLocalizations t, int min,
      {bool optional = false}) {
    return (value) {
      final v = value ?? '';
      if (v.isEmpty) return optional ? null : t.validatorRequired;
      if (v.length < min) return t.validatorMinLength(min);
      return null;
    };
  }

  static String? Function(String?) maxLength(AppLocalizations t, int max) {
    return (value) {
      final v = value ?? '';
      if (v.length > max) return t.validatorMaxLength(max);
      return null;
    };
  }

  static String? Function(String?) url(AppLocalizations t,
      {bool optional = true}) {
    return (value) {
      final v = value?.trim() ?? '';
      if (v.isEmpty) return optional ? null : t.validatorRequired;
      final uri = Uri.tryParse(v);
      if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
        return t.validatorUrl;
      }
      return null;
    };
  }

  /// Compose multiple validators; returns the first non-null error.
  static String? Function(String?) compose(
    List<String? Function(String?)> validators,
  ) {
    return (value) {
      for (final v in validators) {
        final result = v(value);
        if (result != null) return result;
      }
      return null;
    };
  }
}
