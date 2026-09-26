import '../../../../core/result/result.dart';
import '../entities/app_user.dart';
import '../entities/sign_up_result.dart';
import '../repositories/auth_repository.dart';

class SignIn {
  const SignIn(this._repository);
  final AuthRepository _repository;

  Future<Result<AppUser>> call({
    required String email,
    required String password,
  }) => _repository.signIn(email: email.trim(), password: password);
}

class SignUp {
  const SignUp(this._repository);
  final AuthRepository _repository;

  Future<Result<SignUpResult>> call({
    required String email,
    required String password,
    String? fullName,
  }) {
    final name = fullName?.trim();
    return _repository.signUp(
      email: email.trim(),
      password: password,
      fullName: (name == null || name.isEmpty) ? null : name,
    );
  }
}

class SignOut {
  const SignOut(this._repository);
  final AuthRepository _repository;

  Future<Result<void>> call() => _repository.signOut();
}

class GetCurrentUser {
  const GetCurrentUser(this._repository);
  final AuthRepository _repository;

  AppUser? call() => _repository.currentUser;
}

class WatchAuthState {
  const WatchAuthState(this._repository);
  final AuthRepository _repository;

  Stream<AppUser?> call() => _repository.watchAuthState();
}
