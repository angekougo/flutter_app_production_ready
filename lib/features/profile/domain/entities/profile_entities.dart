import 'package:equatable/equatable.dart';

/// Compte de l'utilisateur, tel que renvoyé par `GET /auth/v1/user`.
class UserProfile extends Equatable {
  const UserProfile({
    required this.id,
    required this.email,
    this.fullName,
    this.createdAt,
    this.lastSignInAt,
    this.provider,
  });

  final String id;
  final String email;
  final String? fullName;
  final DateTime? createdAt;
  final DateTime? lastSignInAt;

  /// Méthode d'authentification (« email »).
  final String? provider;

  @override
  List<Object?> get props => [
    id,
    email,
    fullName,
    createdAt,
    lastSignInAt,
    provider,
  ];
}

/// État de la session locale (JWT).
class SessionInfo extends Equatable {
  const SessionInfo({required this.hasSession, this.expiresAt});

  final bool hasSession;

  /// Expiration du JWT d'accès courant.
  final DateTime? expiresAt;

  /// Durée restante avant expiration (négative si expiré).
  Duration? remaining(DateTime now) => expiresAt?.difference(now);

  bool isActive(DateTime now) =>
      hasSession && (expiresAt == null || expiresAt!.isAfter(now));

  @override
  List<Object?> get props => [hasSession, expiresAt];
}

/// Ce qui est disponible sans connexion.
class OfflineStats extends Equatable {
  const OfflineStats({
    required this.cachedMovies,
    required this.favorites,
    this.lastUpdate,
  });

  final int cachedMovies;
  final int favorites;
  final DateTime? lastUpdate;

  @override
  List<Object?> get props => [cachedMovies, favorites, lastUpdate];
}
