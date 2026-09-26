import 'package:flutter_app_production_ready/core/error/failures.dart';
import 'package:flutter_app_production_ready/core/result/result.dart';
import 'package:flutter_app_production_ready/features/movies/domain/entities/genre.dart';
import 'package:flutter_app_production_ready/features/movies/domain/entities/movie.dart';
import 'package:flutter_app_production_ready/features/movies/domain/entities/movie_category.dart';
import 'package:flutter_app_production_ready/features/movies/domain/entities/movie_details.dart';
import 'package:flutter_app_production_ready/features/movies/domain/entities/paginated_movies.dart';
import 'package:flutter_app_production_ready/features/movies/domain/repositories/movie_repository.dart';

/// Repository en mémoire pour les tests de widgets.
class FakeMovieRepository implements MovieRepository {
  FakeMovieRepository({
    Map<MovieCategory, List<Movie>>? movies,
    this.genres = const [Genre(id: 18, name: 'Drame')],
    this.fromCache = false,
    this.cachedAt,
    this.failure,
  }) : movies = movies ?? const {};

  final Map<MovieCategory, List<Movie>> movies;
  final List<Genre> genres;
  final bool fromCache;
  final DateTime? cachedAt;

  /// Si défini, toutes les requêtes échouent avec cet échec.
  Failure? failure;

  Result<T> _result<T>(T data) => failure != null
      ? Error(failure!)
      : Success(data, fromCache: fromCache, cachedAt: cachedAt);

  @override
  Future<Result<PaginatedMovies>> getMoviesByCategory(
    MovieCategory category, {
    int page = 1,
  }) async => _result(
    PaginatedMovies(
      movies: movies[category] ?? const [],
      page: page,
      totalPages: 1,
      totalResults: movies[category]?.length ?? 0,
    ),
  );

  @override
  Future<Result<PaginatedMovies>> getPopularMovies({int page = 1}) =>
      getMoviesByCategory(MovieCategory.popular, page: page);

  @override
  Future<Result<PaginatedMovies>> getTrendingMovies({int page = 1}) =>
      getMoviesByCategory(MovieCategory.trending, page: page);

  @override
  Future<Result<PaginatedMovies>> getNowPlayingMovies({int page = 1}) =>
      getMoviesByCategory(MovieCategory.nowPlaying, page: page);

  @override
  Future<Result<List<Genre>>> getGenres() async => _result(genres);

  /// Résultats de recherche par requête (clé en minuscules).
  final Map<String, List<Movie>> searchResults = {};
  final List<String> recentSearches = [];
  final List<String> searchCalls = [];

  @override
  Future<Result<PaginatedMovies>> searchMovies(
    String query, {
    int page = 1,
  }) async {
    searchCalls.add(query);
    final results = searchResults[query.toLowerCase()] ?? const <Movie>[];
    return _result(
      PaginatedMovies(
        movies: results,
        page: page,
        totalPages: 1,
        totalResults: results.length,
      ),
    );
  }

  @override
  Future<Result<List<String>>> getRecentSearches({int limit = 8}) async =>
      Success(recentSearches.take(limit).toList());

  final Map<int, MovieDetails> details = {};

  @override
  Future<Result<MovieDetails>> getMovieDetails(int movieId) async {
    final found = details[movieId];
    if (failure != null) return Error(failure!);
    if (found == null) return const Error(NotFoundFailure());
    return Success(found, fromCache: fromCache, cachedAt: cachedAt);
  }
}
