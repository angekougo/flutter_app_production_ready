import 'package:equatable/equatable.dart';

/// Erreurs métier exposées par les Repositories à la présentation.
///
/// Chaque [Failure] porte un [message] prêt à être affiché à l'utilisateur.
sealed class Failure extends Equatable {
  const Failure(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Vous êtes hors connexion.']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Impossible de contacter le serveur.']);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Votre session a expiré.']);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Film introuvable.']);
}

class CacheFailure extends Failure {
  const CacheFailure([
    super.message = 'Impossible de charger les données. Aucune donnée hors ligne n’est disponible.',
  ]);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Email ou mot de passe incorrect.']);
}

/// Erreur imprévue. Les écrans affichent déjà « Impossible de charger les
/// données. » en titre : le message apporte un complément.
class UnknownFailure extends Failure {
  const UnknownFailure([
    super.message =
        'Une erreur inattendue est survenue. Réessayez dans un instant.',
  ]);
}
