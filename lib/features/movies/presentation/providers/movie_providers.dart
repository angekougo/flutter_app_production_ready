import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/storage/isar_service.dart';
import '../../../../shared/models/fetched.dart';
import '../../data/local/movie_local_data_source.dart';
import '../../data/remote/movie_remote_data_source.dart';
import '../../data/repositories/movie_repository_impl.dart';
import '../../domain/entities/genre.dart';
import '../../domain/entities/movie_details.dart';
import '../../domain/entities/paginated_movies.dart';
import '../../domain/repositories/movie_repository.dart';
import '../../domain/usecases/movie_usecases.dart';

// ─── Injection de dépendances ────────────────────────────────────────────────

final movieRemoteDataSourceProvider = Provider<MovieRemoteDataSource>(
  (ref) => TmdbMovieRemoteDataSource(ref.watch(tmdbDioProvider)),
);

final movieLocalDataSourceProvider = Provider<MovieLocalDataSource>(
  (ref) => IsarMovieLocalDataSource(ref.watch(isarProvider)),
);

final movieRepositoryProvider = Provider<MovieRepository>(
  (ref) => MovieRepositoryImpl(
    remote: ref.watch(movieRemoteDataSourceProvider),
    local: ref.watch(movieLocalDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  ),
);

final getPopularMoviesProvider = Provider(
  (ref) => GetPopularMovies(ref.watch(movieRepositoryProvider)),
);
final getTrendingMoviesProvider = Provider(
  (ref) => GetTrendingMovies(ref.watch(movieRepositoryProvider)),
);
final getNowPlayingMoviesProvider = Provider(
  (ref) => GetNowPlayingMovies(ref.watch(movieRepositoryProvider)),
);
final getMoviesByCategoryProvider = Provider(
  (ref) => GetMoviesByCategory(ref.watch(movieRepositoryProvider)),
);
final searchMoviesProvider = Provider(
  (ref) => SearchMovies(ref.watch(movieRepositoryProvider)),
);
final getRecentSearchesProvider = Provider(
  (ref) => GetRecentSearches(ref.watch(movieRepositoryProvider)),
);
final getMovieDetailsProvider = Provider(
  (ref) => GetMovieDetails(ref.watch(movieRepositoryProvider)),
);
final getGenresProvider = Provider(
  (ref) => GetGenres(ref.watch(movieRepositoryProvider)),
);

// ─── État : loading / success (Fetched) / error (Failure) ────────────────────

final popularMoviesProvider = FutureProvider<Fetched<PaginatedMovies>>(
  (ref) => ref.watch(getPopularMoviesProvider)().orThrow(),
);

final trendingMoviesProvider = FutureProvider<Fetched<PaginatedMovies>>(
  (ref) => ref.watch(getTrendingMoviesProvider)().orThrow(),
);

final nowPlayingMoviesProvider = FutureProvider<Fetched<PaginatedMovies>>(
  (ref) => ref.watch(getNowPlayingMoviesProvider)().orThrow(),
);

final genresProvider = FutureProvider<Fetched<List<Genre>>>(
  (ref) => ref.watch(getGenresProvider)().orThrow(),
);

/// Nom des genres par id (vide tant que les genres ne sont pas chargés).
final genreNamesProvider = Provider<Map<int, String>>((ref) {
  final genres = ref.watch(genresProvider).value?.data ?? const <Genre>[];
  return {for (final g in genres) g.id: g.name};
});

/// Fiche d'un film (libérée quand l'écran est quitté).
final movieDetailsProvider = FutureProvider.autoDispose
    .family<Fetched<MovieDetails>, int>(
      (ref, movieId) => ref.watch(getMovieDetailsProvider)(movieId).orThrow(),
    );
