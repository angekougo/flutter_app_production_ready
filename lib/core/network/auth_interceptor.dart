import 'package:dio/dio.dart';

/// Source des jetons de l'utilisateur connecté. Implémentée par la feature
/// auth (Supabase) ; le `core` n'en connaît que ce contrat.
abstract interface class AuthTokenProvider {
  /// JWT d'accès courant, ou `null` sans session.
  String? get accessToken;

  /// `true` si le JWT courant est expiré (ou sur le point de l'être).
  bool get isAccessTokenExpired;

  /// Échange le refresh token contre un nouveau JWT. Renvoie `null` si la
  /// session ne peut pas être prolongée (refresh token révoqué ou expiré).
  Future<String?> refreshAccessToken();
}

/// Injecte le JWT de l'utilisateur (`Authorization: Bearer …`) et gère son
/// renouvellement :
///
/// 1. avant la requête, un JWT expiré est rafraîchi ;
/// 2. sur une réponse 401, le JWT est rafraîchi une fois puis la requête
///    est rejouée ;
/// 3. si le rafraîchissement échoue, la 401 est propagée (→ « Votre
///    session a expiré. »).
///
/// [QueuedInterceptor] traite les requêtes une par une : plusieurs 401
/// simultanées ne déclenchent qu'un seul rafraîchissement.
///
/// À ne pas confondre avec `TmdbInterceptor` : le JWT Supabase authentifie
/// l'utilisateur Cinéthèque, la clé TMDB authentifie l'application.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({required this._tokens, required this._dio});

  final AuthTokenProvider _tokens;

  /// Client dont on reprend la configuration pour rejouer la requête.
  final Dio _dio;

  /// Marque une requête déjà rejouée : évite toute boucle infinie.
  static const _retriedKey = 'auth_retried';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    var token = _tokens.accessToken;
    if (token != null && _tokens.isAccessTokenExpired) {
      token = await _tokens.refreshAccessToken() ?? token;
    }
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;
    final isUnauthorized = err.response?.statusCode == 401;
    final alreadyRetried = request.extra[_retriedKey] == true;

    if (!isUnauthorized || alreadyRetried) return handler.next(err);

    // Une requête précédente de la file a peut-être déjà renouvelé le JWT.
    final sentToken = request.headers['Authorization'];
    final current = _tokens.accessToken;
    final newToken = (current != null && sentToken != 'Bearer $current')
        ? current
        : await _tokens.refreshAccessToken();

    if (newToken == null) return handler.next(err);

    // Rejeu via un client sans intercepteurs : rejouer avec [_dio] ferait
    // repasser une nouvelle 401 dans cette file d'attente, qui attend
    // elle-même la fin de ce traitement → interblocage.
    final retryClient = Dio(_dio.options)
      ..httpClientAdapter = _dio.httpClientAdapter;
    try {
      final retried = await retryClient.fetch<dynamic>(
        request
          ..headers['Authorization'] = 'Bearer $newToken'
          ..extra[_retriedKey] = true,
      );
      handler.resolve(retried);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }
}
