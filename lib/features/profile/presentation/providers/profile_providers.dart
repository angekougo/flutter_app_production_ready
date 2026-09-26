import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../shared/models/fetched.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../favorites/presentation/providers/favorites_providers.dart';
import '../../../movies/presentation/providers/movie_providers.dart';
import '../../data/datasources/profile_data_sources.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/profile_entities.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/profile_usecases.dart';

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepositoryImpl(
    remote: SupabaseProfileRemoteDataSource(ref.watch(supabaseDioProvider)),
    session: SupabaseSessionDataSource(ref.watch(supabaseClientProvider).auth),
    movies: ref.watch(movieLocalDataSourceProvider),
    favorites: ref.watch(favoritesLocalDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  ),
);

final getProfileProvider = Provider(
  (ref) => GetProfile(ref.watch(profileRepositoryProvider)),
);
final getSessionInfoProvider = Provider(
  (ref) => GetSessionInfo(ref.watch(profileRepositoryProvider)),
);
final getOfflineStatsProvider = Provider(
  (ref) => GetOfflineStats(ref.watch(profileRepositoryProvider)),
);

/// Compte lu via `GET /auth/v1/user` (Dio + AuthInterceptor).
final profileProvider = FutureProvider.autoDispose<Fetched<UserProfile>>(
  (ref) => ref.watch(getProfileProvider)().orThrow(),
);

/// Heure courante, rafraîchie toutes les 30 s (compte à rebours du JWT,
/// « il y a 2 min »).
final clockProvider = StreamProvider.autoDispose<DateTime>(
  (ref) => Stream.periodic(
    const Duration(seconds: 30),
    (_) => DateTime.now(),
  ).cast<DateTime>().startWith(DateTime.now()),
);

/// État de la session ; réévalué à chaque événement d'auth (dont le
/// rafraîchissement automatique du JWT).
final sessionInfoProvider = Provider.autoDispose<SessionInfo>((ref) {
  ref.watch(authStateProvider);
  return ref.watch(getSessionInfoProvider)();
});

/// Statistiques hors ligne ; recalculées quand les favoris changent.
final offlineStatsProvider = FutureProvider.autoDispose<OfflineStats>((
  ref,
) async {
  ref.watch(favoritesProvider);
  return (await ref.watch(getOfflineStatsProvider)().orThrow()).data;
});

extension _StartWith<T> on Stream<T> {
  Stream<T> startWith(T value) async* {
    yield value;
    yield* this;
  }
}
