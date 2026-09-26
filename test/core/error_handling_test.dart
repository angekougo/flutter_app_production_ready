import 'package:dio/dio.dart';
import 'package:flutter_app_production_ready/core/error/exceptions.dart';
import 'package:flutter_app_production_ready/core/error/failure_mapper.dart';
import 'package:flutter_app_production_ready/core/error/failures.dart';
import 'package:flutter_app_production_ready/core/network/dio_error_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  DioException badResponse(int status) => DioException(
    requestOptions: RequestOptions(path: '/movie/1'),
    type: DioExceptionType.badResponse,
    response: Response(
      requestOptions: RequestOptions(path: '/movie/1'),
      statusCode: status,
      data: {'status_message': 'boom'},
    ),
  );

  group('mapDioException', () {
    test('timeout et erreur de connexion → NetworkException', () {
      for (final type in [
        DioExceptionType.connectionTimeout,
        DioExceptionType.receiveTimeout,
        DioExceptionType.connectionError,
      ]) {
        final e = DioException(requestOptions: RequestOptions(), type: type);
        expect(mapDioException(e), isA<NetworkException>());
      }
    });

    test('codes HTTP → exceptions typées', () {
      expect(mapDioException(badResponse(401)), isA<UnauthorizedException>());
      expect(mapDioException(badResponse(404)), isA<NotFoundException>());
      final server = mapDioException(badResponse(500));
      expect(server, isA<ServerException>());
      expect((server as ServerException).statusCode, 500);
      expect(server.message, 'boom');
    });
  });

  group('mapExceptionToFailure', () {
    test('chaque exception donne le message utilisateur attendu', () {
      expect(
        mapExceptionToFailure(const NetworkException()).message,
        'Vous êtes hors connexion.',
      );
      expect(
        mapExceptionToFailure(const UnauthorizedException()).message,
        'Votre session a expiré.',
      );
      expect(
        mapExceptionToFailure(const NotFoundException()),
        const NotFoundFailure(),
      );
      expect(mapExceptionToFailure(StateError('?')), isA<UnknownFailure>());
    });
  });
}
