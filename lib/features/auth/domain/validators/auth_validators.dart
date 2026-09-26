/// Erreur de saisie d'un formulaire d'authentification. Le texte affiché est
/// choisi par la présentation, dans la langue de l'utilisateur.
enum AuthValidationError {
  emailRequired,
  emailInvalid,
  passwordRequired,
  newPasswordRequired,
  passwordTooShort,
  confirmationRequired,
  confirmationMismatch,
}

/// Règles de validation des formulaires d'authentification (Dart pur,
/// testables sans Flutter). Chaque méthode renvoie une erreur ou `null`.
abstract final class AuthValidators {
  static const minPasswordLength = 8;

  static final _emailRegExp = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');

  static AuthValidationError? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return AuthValidationError.emailRequired;
    if (!_emailRegExp.hasMatch(v)) return AuthValidationError.emailInvalid;
    return null;
  }

  /// Connexion : on ne vérifie que la présence du mot de passe.
  static AuthValidationError? requiredPassword(String? value) =>
      (value == null || value.isEmpty)
      ? AuthValidationError.passwordRequired
      : null;

  static AuthValidationError? newPassword(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return AuthValidationError.newPasswordRequired;
    if (v.length < minPasswordLength) {
      return AuthValidationError.passwordTooShort;
    }
    return null;
  }

  static AuthValidationError? confirmation(String? value, String password) {
    if (value == null || value.isEmpty) {
      return AuthValidationError.confirmationRequired;
    }
    if (value != password) return AuthValidationError.confirmationMismatch;
    return null;
  }
}

enum PasswordStrength {
  empty(0),
  weak(1),
  fair(2),
  good(3),
  strong(4);

  const PasswordStrength(this.score);

  /// Nombre de segments allumés sur 4.
  final int score;

  static PasswordStrength evaluate(String password) {
    if (password.isEmpty) return empty;
    if (password.length < AuthValidators.minPasswordLength) return weak;

    var points = 1;
    final hasLower = password.contains(RegExp('[a-z]'));
    final hasUpper = password.contains(RegExp('[A-Z]'));
    if (hasLower && hasUpper) points++;
    if (password.contains(RegExp(r'\d'))) points++;
    if (password.contains(RegExp(r'[^A-Za-z0-9]')) || password.length >= 14) {
      points++;
    }
    return values[points.clamp(1, 4)];
  }
}
