import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/result/result.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/entities/sign_up_result.dart';
import 'auth_providers.dart';

/// Formulaire de connexion : loading → utilisateur connecté | erreur ([Failure]).
///
/// En cas de succès, aucune navigation n'est faite ici : le flux de session
/// émet l'utilisateur et le routeur redirige vers l'accueil.
class LoginController extends AsyncNotifier<AppUser?> {
  @override
  FutureOr<AppUser?> build() => null;

  Future<void> submit({required String email, required String password}) async {
    state = const AsyncLoading();
    final result = await ref.read(signInProvider)(
      email: email,
      password: password,
    );
    if (!ref.mounted) return;
    state = result.when(
      success: AsyncData.new,
      failure: (failure) => AsyncError(failure, StackTrace.current),
    );
  }

  void clearError() {
    if (state.hasError) state = const AsyncData(null);
  }
}

final loginControllerProvider =
    AsyncNotifierProvider.autoDispose<LoginController, AppUser?>(
      LoginController.new,
    );

/// Formulaire d'inscription. L'état porte le [SignUpResult] pour que l'écran
/// sache si une confirmation par email est nécessaire.
class RegisterController extends AsyncNotifier<SignUpResult?> {
  @override
  FutureOr<SignUpResult?> build() => null;

  Future<void> submit({
    required String email,
    required String password,
    String? fullName,
  }) async {
    state = const AsyncLoading();
    final result = await ref.read(signUpProvider)(
      email: email,
      password: password,
      fullName: fullName,
    );
    if (!ref.mounted) return;
    state = result.when(
      success: AsyncData.new,
      failure: (failure) => AsyncError(failure, StackTrace.current),
    );
  }

  void clearError() {
    if (state.hasError) state = const AsyncData(null);
  }
}

final registerControllerProvider =
    AsyncNotifierProvider.autoDispose<RegisterController, SignUpResult?>(
      RegisterController.new,
    );

class LogoutController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  /// Renvoie le résultat pour que l'appelant puisse notifier l'utilisateur :
  /// le routeur quitte l'écran Profil dès que la session est supprimée, donc
  /// ce contrôleur peut être libéré avant la fin de l'appel.
  Future<Result<void>> logout() async {
    state = const AsyncLoading();
    final signOut = ref.read(signOutProvider);
    final result = await signOut();
    if (ref.mounted) {
      state = result.when(
        success: (_) => const AsyncData(null),
        failure: (failure) => AsyncError(failure, StackTrace.current),
      );
    }
    return result;
  }
}

final logoutControllerProvider =
    AsyncNotifierProvider.autoDispose<LogoutController, void>(
      LogoutController.new,
    );
