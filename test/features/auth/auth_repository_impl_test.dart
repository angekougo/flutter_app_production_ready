import 'package:flutter_app_production_ready/core/error/exceptions.dart';
import 'package:flutter_app_production_ready/core/error/failures.dart';
import 'package:flutter_app_production_ready/core/result/result.dart';
import 'package:flutter_app_production_ready/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_app_production_ready/features/auth/data/models/user_model.dart';
import 'package:flutter_app_production_ready/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_app_production_ready/features/auth/domain/entities/sign_up_result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late MockAuthRemoteDataSource remote;
  late AuthRepositoryImpl repository;

  const user = UserModel(
    id: 'u1',
    email: 'awa.konan@exemple.com',
    fullName: 'Awa Konan',
  );

  setUp(() {
    remote = MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(remote);
  });

  group('signIn', () {
    test('renvoie Success avec l’utilisateur connecté', () async {
      when(
        () => remote.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => user);

      final result = await repository.signIn(
        email: user.email,
        password: 'secret123',
      );

      expect(result, isA<Success<Object?>>());
      expect(result.dataOrNull, user);
      verify(() => remote.signIn(email: user.email, password: 'secret123'))
          .called(1);
    });

    test(
      'identifiants invalides → AuthFailure avec la cause du datasource',
      () async {
        when(
          () => remote.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(const AuthException(AuthErrorReason.invalidCredentials));

        final result = await repository.signIn(
          email: user.email,
          password: 'x',
        );

        expect(
          (result as Error).failure,
          const AuthFailure(AuthErrorReason.invalidCredentials),
        );
      },
    );

    test('pas de réseau → NetworkFailure', () async {
      when(
        () => remote.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(const NetworkException());

      final result = await repository.signIn(email: user.email, password: 'x');

      expect((result as Error).failure, isA<NetworkFailure>());
    });
  });

  group('signUp', () {
    test('sans session ouverte → confirmation email requise', () async {
      when(
        () => remote.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
          fullName: any(named: 'fullName'),
        ),
      ).thenAnswer((_) async => (user: user, hasSession: false));

      final result = await repository.signUp(
        email: user.email,
        password: 'Secret123!',
        fullName: 'Awa Konan',
      );

      expect(
        result.dataOrNull,
        const SignUpResult(user: user, emailConfirmationRequired: true),
      );
    });
  });

  group('signOut', () {
    test('erreur inattendue → UnknownFailure', () async {
      when(() => remote.signOut()).thenThrow(StateError('boom'));

      final result = await repository.signOut();

      expect((result as Error).failure, isA<UnknownFailure>());
    });
  });
}
