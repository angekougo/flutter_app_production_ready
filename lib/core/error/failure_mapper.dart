import 'exceptions.dart';
import 'failures.dart';

/// Traduit une exception technique en [Failure] métier.
Failure mapExceptionToFailure(Object error) => switch (error) {
  NetworkException() => const NetworkFailure(),
  UnauthorizedException() => const UnauthorizedFailure(),
  NotFoundException() => const NotFoundFailure(),
  CacheException() => const CacheFailure(),
  AuthException(:final message) =>
    message == null ? const AuthFailure() : AuthFailure(message),
  ServerException() => const ServerFailure(),
  _ => const UnknownFailure(),
};
