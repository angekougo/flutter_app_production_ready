import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'api_constants.dart';

/// Fabrique centralisée des instances [Dio] : base URL, timeouts, headers,
/// intercepteurs et logs (en debug uniquement).
abstract final class DioClient {
  static Dio create({
    required String baseUrl,
    Map<String, String> headers = const {},
    List<Interceptor> interceptors = const [],
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: headers,
      ),
    );

    dio.interceptors.addAll(interceptors);

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestHeader: false,
          responseHeader: false,
          responseBody: false,
          logPrint: (line) => debugPrint('[dio] $line'),
        ),
      );
    }
    return dio;
  }
}
