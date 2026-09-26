import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import '../../../../core/config/env.dart';
import '../../../../core/network/auth_interceptor.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/datasources/supabase_auth_token_provider.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/auth_usecases.dart';

// ─── Injection de dépendances ────────────────────────────────────────────────

final supabaseClientProvider = Provider<sb.SupabaseClient>(
  (ref) => sb.Supabase.instance.client,
);

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) => SupabaseAuthRemoteDataSource(ref.watch(supabaseClientProvider).auth),
);

final authTokenProviderProvider = Provider<AuthTokenProvider>(
  (ref) => SupabaseAuthTokenProvider(ref.watch(supabaseClientProvider).auth),
);

/// Client Dio de l'API REST Supabase, authentifié par le JWT de
/// l'utilisateur (AuthInterceptor) : distinct du client TMDB.
final supabaseDioProvider = Provider<Dio>((ref) {
  final dio = DioClient.create(
    baseUrl: Env.supabaseUrl,
    headers: {'apikey': Env.supabasePublishableKey},
  );
  // En tête de chaîne : les logs voient la requête finale.
  dio.interceptors.insert(
    0,
    AuthInterceptor(tokens: ref.watch(authTokenProviderProvider), dio: dio),
  );
  return dio;
});

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref.watch(authRemoteDataSourceProvider)),
);

final signInProvider = Provider(
  (ref) => SignIn(ref.watch(authRepositoryProvider)),
);
final signUpProvider = Provider(
  (ref) => SignUp(ref.watch(authRepositoryProvider)),
);
final signOutProvider = Provider(
  (ref) => SignOut(ref.watch(authRepositoryProvider)),
);
final getCurrentUserProvider = Provider(
  (ref) => GetCurrentUser(ref.watch(authRepositoryProvider)),
);
final watchAuthStateProvider = Provider(
  (ref) => WatchAuthState(ref.watch(authRepositoryProvider)),
);

// ─── État de session ─────────────────────────────────────────────────────────

/// Flux des changements de session (connexion, déconnexion, refresh du JWT).
final authStateProvider = StreamProvider<AppUser?>(
  (ref) => ref.watch(watchAuthStateProvider)(),
);

/// Utilisateur connecté, ou `null`. Disponible immédiatement au démarrage
/// grâce à la session restaurée, avant même le premier événement du flux.
final currentUserProvider = Provider<AppUser?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.hasValue
      ? authState.value
      : ref.watch(getCurrentUserProvider)();
});
