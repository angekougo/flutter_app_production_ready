import 'package:equatable/equatable.dart';

/// Erreurs métier exposées par les Repositories à la présentation.
///
/// Une [Failure] ne porte aucun texte : elle décrit *ce qui* s'est passé, et
/// la présentation choisit le message dans la langue de l'utilisateur
/// (voir `FailureMessages` dans `l10n/l10n_x.dart`).
sealed class Failure extends Equatable {
  const Failure();

  @override
  List<Object?> get props => [];
}

class NetworkFailure extends Failure {
  const NetworkFailure();
}

class ServerFailure extends Failure {
  const ServerFailure();
}

enum UnauthorizedReason { sessionExpired, notSignedIn }

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([this.reason = UnauthorizedReason.sessionExpired]);
  final UnauthorizedReason reason;

  @override
  List<Object?> get props => [reason];
}

enum NotFoundResource { movie, actor }

class NotFoundFailure extends Failure {
  const NotFoundFailure([this.resource = NotFoundResource.movie]);
  final NotFoundResource resource;

  @override
  List<Object?> get props => [resource];
}

/// Hors ligne (ou cache illisible) et aucune donnée locale disponible.
class CacheFailure extends Failure {
  const CacheFailure();
}

/// Cause d'un échec d'authentification, indépendante du fournisseur (Supabase).
enum AuthErrorReason {
  invalidCredentials,
  emailNotConfirmed,
  userAlreadyExists,
  weakPassword,
  invalidEmail,
  rateLimited,
  signupDisabled,
  unknown,
}

class AuthFailure extends Failure {
  const AuthFailure([this.reason = AuthErrorReason.invalidCredentials]);
  final AuthErrorReason reason;

  @override
  List<Object?> get props => [reason];
}

/// Erreur imprévue. Les écrans affichent déjà « Impossible de charger les
/// données. » en titre : le message apporte un complément.
class UnknownFailure extends Failure {
  const UnknownFailure();
}
