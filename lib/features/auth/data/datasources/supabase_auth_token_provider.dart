import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import '../../../../core/network/auth_interceptor.dart';

/// Jetons de la session Supabase courante (JWT d'accès + refresh token).
class SupabaseAuthTokenProvider implements AuthTokenProvider {
  SupabaseAuthTokenProvider(this._auth);

  final sb.GoTrueClient _auth;

  /// Marge de sécurité : un JWT qui expire dans moins de 30 s est renouvelé.
  static const _expiryMargin = Duration(seconds: 30);

  @override
  String? get accessToken => _auth.currentSession?.accessToken;

  @override
  bool get isAccessTokenExpired {
    final expiresAt = _auth.currentSession?.expiresAt;
    if (expiresAt == null) return false;
    final expiry = DateTime.fromMillisecondsSinceEpoch(expiresAt * 1000);
    return DateTime.now().add(_expiryMargin).isAfter(expiry);
  }

  @override
  Future<String?> refreshAccessToken() async {
    try {
      final response = await _auth.refreshSession();
      return response.session?.accessToken;
    } on Object {
      // Refresh token révoqué/expiré, ou pas de réseau : la requête
      // échouera avec sa 401 d'origine.
      return null;
    }
  }
}
