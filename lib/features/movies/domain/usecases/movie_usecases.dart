import '../../../../core/result/result.dart';
import '../entities/genre.dart';
import '../entities/movie_category.dart';
import '../entities/movie_details.dart';
import '../entities/paginated_movies.dart';
import '../repositories/movie_repository.dart';

class GetPopularMovies {
  const GetPopularMovies(this._repository);
  final MovieRepository _repository;

  Future<Result<PaginatedMovies>> call({int page = 1}) =>
      _repository.getPopularMovies(page: page);
}

class GetTrendingMovies {
  const GetTrendingMovies(this._repository);
  final MovieRepository _repository;

  Future<Result<PaginatedMovies>> call({int page = 1}) =>
      _repository.getTrendingMovies(page: page);
}

class GetNowPlayingMovies {
  const GetNowPlayingMovies(this._repository);
  final MovieRepository _repository;

  Future<Result<PaginatedMovies>> call({int page = 1}) =>
      _repository.getNowPlayingMovies(page: page);
}

/// Liste paginée d'une catégorie (écran « Tout voir »).
class GetMoviesByCategory {
  const GetMoviesByCategory(this._repository);
  final MovieRepository _repository;

  Future<Result<PaginatedMovies>> call(
    MovieCategory category, {
    int page = 1,
  }) => _repository.getMoviesByCategory(category, page: page);
}

class GetGenres {
  const GetGenres(this._repository);
  final MovieRepository _repository;

  Future<Result<List<Genre>>> call() => _repository.getGenres();
}

/// Recherche de films par titre.
class SearchMovies {
  const SearchMovies(this._repository);
  final MovieRepository _repository;

  /// Longueur minimale d'une requête (évite des résultats non pertinents).
  static const minQueryLength = 2;

  static bool isValidQuery(String query) =>
      query.trim().length >= minQueryLength;

  Future<Result<PaginatedMovies>> call(String query, {int page = 1}) async {
    final trimmed = query.trim();
    if (!isValidQuery(trimmed)) {
      return const Success(
        PaginatedMovies(movies: [], page: 1, totalPages: 1, totalResults: 0),
      );
    }
    return _repository.searchMovies(trimmed, page: page);
  }
}

class GetRecentSearches {
  const GetRecentSearches(this._repository);
  final MovieRepository _repository;

  Future<Result<List<String>>> call({int limit = 8}) =>
      _repository.getRecentSearches(limit: limit);
}

class GetMovieDetails {
  const GetMovieDetails(this._repository);
  final MovieRepository _repository;

  Future<Result<MovieDetails>> call(int movieId) =>
      _repository.getMovieDetails(movieId);
}
