import 'package:dio/dio.dart';

import '../constants/app_constants.dart';

/// Authentifie l'**application** auprès de TMDB (Bearer « API Read Access
/// Token ») et ajoute la langue/région par défaut à chaque requête.
///
/// À ne pas confondre avec `AuthInterceptor`, qui injecte le JWT Supabase de
/// l'**utilisateur** connecté.
class TmdbInterceptor extends Interceptor {
  TmdbInterceptor(this._readToken);

  final String _readToken;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Authorization'] = 'Bearer $_readToken';
    options.headers['Accept'] = 'application/json';
    options.queryParameters.putIfAbsent(
      'language',
      () => AppConstants.tmdbLanguage,
    );
    handler.next(options);
  }
}
