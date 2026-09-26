import 'package:dio/dio.dart';

import '../error/exceptions.dart';

/// Convertit une [DioException] en [AppException] typée.
///
/// Première étape de la chaîne d'erreurs :
/// DioException → AppException → Failure → Result → Provider → UI.
AppException mapDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
    case DioExceptionType.connectionError:
      return NetworkException(e.message);
    case DioExceptionType.badResponse:
      final status = e.response?.statusCode;
      final message = _extractMessage(e.response?.data) ?? e.message;
      return switch (status) {
        401 || 403 => UnauthorizedException(message),
        404 => NotFoundException(message),
        _ => ServerException(statusCode: status, message: message),
      };
    case DioExceptionType.cancel:
    case DioExceptionType.badCertificate:
    case DioExceptionType.unknown:
      // Une SocketException est remontée en `unknown` sur certaines plateformes.
      if (e.error.toString().contains('SocketException')) {
        return NetworkException(e.message);
      }
      return ServerException(message: e.message);
  }
}

/// TMDB renvoie `status_message`, Supabase `msg` ou `message`.
String? _extractMessage(Object? data) {
  if (data is Map) {
    for (final key in const ['status_message', 'msg', 'message', 'error']) {
      final value = data[key];
      if (value is String && value.isNotEmpty) return value;
    }
  }
  return null;
}
