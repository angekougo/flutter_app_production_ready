import 'package:equatable/equatable.dart';

import 'app_user.dart';

/// Résultat d'une inscription.
///
/// Si la confirmation par email est activée côté Supabase, le compte est créé
/// mais aucune session n'est ouverte : l'utilisateur doit d'abord valider
/// son adresse.
class SignUpResult extends Equatable {
  const SignUpResult({
    required this.user,
    required this.emailConfirmationRequired,
  });

  final AppUser user;
  final bool emailConfirmationRequired;

  @override
  List<Object?> get props => [user, emailConfirmationRequired];
}
