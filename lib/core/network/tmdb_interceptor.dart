import 'package:dio/dio.dart';

/// Authentifie l'**application** auprès de TMDB (Bearer « API Read Access
/// Token ») et ajoute la langue des contenus à chaque requête.
///
/// À ne pas confondre avec `AuthInterceptor`, qui injecte le JWT Supabase de
/// l'**utilisateur** connecté.
class TmdbInterceptor extends Interceptor {
  TmdbInterceptor(this._readToken, {required this.language});

  final String _readToken;

  /// Langue TMDB (ex. « fr-FR »), sauf si la requête en précise une.
  final String language;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Authorization'] = 'Bearer $_readToken';
    options.headers['Accept'] = 'application/json';
    options.queryParameters.putIfAbsent('language', () => language);
    handler.next(options);
  }
}
