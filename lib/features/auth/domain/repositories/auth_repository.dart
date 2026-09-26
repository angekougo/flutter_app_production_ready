import '../../../../core/result/result.dart';
import '../entities/app_user.dart';
import '../entities/sign_up_result.dart';

abstract interface class AuthRepository {
  /// Utilisateur de la session courante (restaurée au démarrage), ou `null`.
  AppUser? get currentUser;

  /// Émet à chaque connexion, déconnexion ou rafraîchissement de session.
  Stream<AppUser?> watchAuthState();

  Future<Result<AppUser>> signIn({
    required String email,
    required String password,
  });

  Future<Result<SignUpResult>> signUp({
    required String email,
    required String password,
    String? fullName,
  });

  Future<Result<void>> signOut();
}
