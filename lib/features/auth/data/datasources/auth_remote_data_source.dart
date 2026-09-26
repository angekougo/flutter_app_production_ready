import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart' show AuthErrorReason;
import '../models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  UserModel? get currentUser;
  Stream<UserModel?> watchAuthState();
  Future<UserModel> signIn({required String email, required String password});

  /// Renvoie l'utilisateur créé et indique si une session a été ouverte.
  Future<({UserModel user, bool hasSession})> signUp({
    required String email,
    required String password,
    String? fullName,
  });

  Future<void> signOut();
}

/// Implémentation Supabase Auth (email / mot de passe).
///
/// Traduit les erreurs Supabase en [AppException] : le reste de l'application
/// ne dépend jamais des types du SDK.
class SupabaseAuthRemoteDataSource implements AuthRemoteDataSource {
  SupabaseAuthRemoteDataSource(this._auth);

  final sb.GoTrueClient _auth;

  @override
  UserModel? get currentUser {
    final user = _auth.currentUser;
    return user == null ? null : UserModel.fromSupabase(user);
  }

  @override
  Stream<UserModel?> watchAuthState() => _auth.onAuthStateChange.map((event) {
    final user = event.session?.user;
    return user == null ? null : UserModel.fromSupabase(user);
  });

  @override
  Future<UserModel> signIn({required String email, required String password}) =>
      _guard(() async {
        final response = await _auth.signInWithPassword(
          email: email,
          password: password,
        );
        final user = response.user;
        if (user == null) {
          throw const AuthException(AuthErrorReason.invalidCredentials);
        }
        return UserModel.fromSupabase(user);
      });

  @override
  Future<({UserModel user, bool hasSession})> signUp({
    required String email,
    required String password,
    String? fullName,
  }) => _guard(() async {
    final response = await _auth.signUp(
      email: email,
      password: password,
      data: {'full_name': ?fullName},
    );
    final user = response.user;
    if (user == null) throw const AuthException();

    // Avec la confirmation email activée, Supabase ne révèle pas qu'un email
    // est déjà inscrit : il renvoie un utilisateur sans identité.
    if (response.session == null && (user.identities?.isEmpty ?? false)) {
      throw const AuthException(AuthErrorReason.userAlreadyExists);
    }
    return (
      user: UserModel.fromSupabase(user),
      hasSession: response.session != null,
    );
  });

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on Object catch (e) {
      // La session locale est supprimée avant l'appel réseau : la
      // déconnexion reste effective hors ligne, on ignore donc l'échec
      // de révocation côté serveur.
      if (!_isNetworkError(e)) rethrow;
    }
  }

  Future<T> _guard<T>(Future<T> Function() body) async {
    try {
      return await body();
    } on AppException {
      rethrow;
    } on sb.AuthRetryableFetchException catch (e) {
      throw NetworkException(e.message);
    } on sb.AuthException catch (e) {
      throw AuthException(_reasonFor(e), e.message);
    } on Object catch (e) {
      if (_isNetworkError(e)) throw NetworkException(e.toString());
      rethrow;
    }
  }

  static bool _isNetworkError(Object e) {
    if (e is sb.AuthRetryableFetchException) return true;
    final text = e.toString();
    return text.contains('SocketException') ||
        text.contains('ClientException') ||
        text.contains('Failed host lookup') ||
        text.contains('Connection');
  }

  static AuthErrorReason _reasonFor(sb.AuthException e) => switch (e.code) {
    'invalid_credentials' => AuthErrorReason.invalidCredentials,
    'email_not_confirmed' => AuthErrorReason.emailNotConfirmed,
    'user_already_exists' ||
    'email_exists' => AuthErrorReason.userAlreadyExists,
    'weak_password' => AuthErrorReason.weakPassword,
    'email_address_invalid' => AuthErrorReason.invalidEmail,
    'over_email_send_rate_limit' ||
    'over_request_rate_limit' => AuthErrorReason.rateLimited,
    'signup_disabled' => AuthErrorReason.signupDisabled,
    _ when e.statusCode == '400' => AuthErrorReason.invalidCredentials,
    _ => AuthErrorReason.unknown,
  };
}
