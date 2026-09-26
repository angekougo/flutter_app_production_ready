import 'package:equatable/equatable.dart';

/// Utilisateur Cinéthèque authentifié.
class AppUser extends Equatable {
  const AppUser({
    required this.id,
    required this.email,
    this.fullName,
    this.createdAt,
  });

  final String id;
  final String email;
  final String? fullName;
  final DateTime? createdAt;

  /// Nom affiché : nom complet, sinon partie locale de l'email.
  String get displayName {
    final name = fullName?.trim();
    return (name == null || name.isEmpty) ? email.split('@').first : name;
  }

  /// Prénom pour la salutation (« BONSOIR, AWA »).
  String get firstName => displayName.split(RegExp(r'\s+')).first;

  /// Initiales pour l'avatar (« AK »).
  String get initials {
    final parts = displayName
        .split(RegExp(r'[\s._-]+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    final first = parts.first[0];
    final second = parts.length > 1 ? parts[1][0] : '';
    return (first + second).toUpperCase();
  }

  @override
  List<Object?> get props => [id, email, fullName, createdAt];
}
