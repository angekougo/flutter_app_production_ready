import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/entities/sign_up_result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remote);

  final AuthRemoteDataSource _remote;

  @override
  AppUser? get currentUser => _remote.currentUser;

  @override
  Stream<AppUser?> watchAuthState() => _remote.watchAuthState();

  @override
  Future<Result<AppUser>> signIn({
    required String email,
    required String password,
  }) => _run(() => _remote.signIn(email: email, password: password));

  @override
  Future<Result<SignUpResult>> signUp({
    required String email,
    required String password,
    String? fullName,
  }) => _run(() async {
    final created = await _remote.signUp(
      email: email,
      password: password,
      fullName: fullName,
    );
    return SignUpResult(
      user: created.user,
      emailConfirmationRequired: !created.hasSession,
    );
  });

  @override
  Future<Result<void>> signOut() => _run(_remote.signOut);

  Future<Result<T>> _run<T>(Future<T> Function() body) async {
    try {
      return Success(await body());
    } on AppException catch (e) {
      return Error(mapExceptionToFailure(e));
    } on Object {
      return const Error(UnknownFailure());
    }
  }
}
