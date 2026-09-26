import '../../../../core/result/result.dart';
import '../entities/genre.dart';
import '../entities/movie_category.dart';
import '../entities/movie_details.dart';
import '../entities/paginated_movies.dart';

/// Contrat d'accès aux films. L'implémentation décide seule de la source
/// (TMDB ou cache Isar) ; un [Success] indique `fromCache` et `cachedAt`
/// quand les données sont servies hors ligne.
abstract interface class MovieRepository {
  Future<Result<PaginatedMovies>> getPopularMovies({int page = 1});

  Future<Result<PaginatedMovies>> getTrendingMovies({int page = 1});

  Future<Result<PaginatedMovies>> getNowPlayingMovies({int page = 1});

  Future<Result<PaginatedMovies>> getMoviesByCategory(
    MovieCategory category, {
    int page = 1,
  });

  Future<Result<List<Genre>>> getGenres();

  /// Recherche par titre. Hors ligne, sert les résultats d'une recherche
  /// identique déjà effectuée (insensible à la casse et aux espaces).
  Future<Result<PaginatedMovies>> searchMovies(String query, {int page = 1});

  /// Dernières recherches mises en cache, de la plus récente à la plus
  /// ancienne (disponibles hors ligne).
  Future<Result<List<String>>> getRecentSearches({int limit = 8});

  /// Fiche complète ; « Film introuvable. » ([NotFoundFailure]) si l'id
  /// n'existe pas chez TMDB.
  Future<Result<MovieDetails>> getMovieDetails(int movieId);
}
