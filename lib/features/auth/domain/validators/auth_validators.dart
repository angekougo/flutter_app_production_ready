/// Règles de validation des formulaires d'authentification (Dart pur,
/// testables sans Flutter). Chaque méthode renvoie un message ou `null`.
abstract final class AuthValidators {
  static const minPasswordLength = 8;

  static final _emailRegExp = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');

  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Saisissez votre email.';
    if (!_emailRegExp.hasMatch(v)) return 'Adresse email invalide.';
    return null;
  }

  /// Connexion : on ne vérifie que la présence du mot de passe.
  static String? requiredPassword(String? value) =>
      (value == null || value.isEmpty) ? 'Saisissez votre mot de passe.' : null;

  static String? newPassword(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Choisissez un mot de passe.';
    if (v.length < minPasswordLength) {
      return '$minPasswordLength caractères minimum.';
    }
    return null;
  }

  static String? confirmation(String? value, String password) {
    if (value == null || value.isEmpty) return 'Confirmez le mot de passe.';
    if (value != password) return 'Les mots de passe ne correspondent pas.';
    return null;
  }
}

enum PasswordStrength {
  empty(0, ''),
  weak(1, 'faible'),
  fair(2, 'moyenne'),
  good(3, 'correcte'),
  strong(4, 'forte');

  const PasswordStrength(this.score, this.label);

  /// Nombre de segments allumés sur 4.
  final int score;
  final String label;

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
