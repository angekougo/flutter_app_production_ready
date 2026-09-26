import 'failures.dart' show AuthErrorReason;

/// Exceptions techniques levées par la couche Data (DataSources).
///
/// Elles ne remontent jamais jusqu'à la présentation : le Repository les
/// convertit en [Failure] (voir `failures.dart`).
sealed class AppException implements Exception {
  const AppException([this.message]);
  final String? message;

  @override
  String toString() => '$runtimeType: ${message ?? ''}';
}

/// Pas de réseau, timeout, DNS…
class NetworkException extends AppException {
  const NetworkException([super.message]);
}

/// Réponse HTTP d'erreur (5xx, 4xx non spécifique).
class ServerException extends AppException {
  const ServerException({this.statusCode, String? message}) : super(message);
  final int? statusCode;
}

/// 401 / session expirée.
class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message]);
}

/// 404.
class NotFoundException extends AppException {
  const NotFoundException([super.message]);
}

/// Erreur de lecture/écriture Isar, ou cache vide.
class CacheException extends AppException {
  const CacheException([super.message]);
}

/// Erreur fonctionnelle d'authentification (identifiants invalides…).
class AuthException extends AppException {
  const AuthException([this.reason = AuthErrorReason.unknown, String? message])
    : super(message);
  final AuthErrorReason reason;
}
