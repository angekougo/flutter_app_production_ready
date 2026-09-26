import 'package:isar_community/isar.dart';

import '../../../../core/error/exceptions.dart';
import 'models/cached_genre.dart';
import 'models/cached_movie.dart';
import 'models/cached_movie_details.dart';
import 'models/cached_movie_list.dart';
import 'models/cached_search.dart';

/// Page de films lue depuis le cache.
typedef CachedMoviePage = ({
  List<CachedMovie> movies,
  int page,
  int totalPages,
  int totalResults,
  DateTime cachedAt,
});

/// Fiche film complète lue depuis le cache.
typedef CachedMovieFull = ({
  CachedMovie movie,
  CachedMovieDetails details,
  List<CachedMovie> similar,
});

/// Accès au cache local des films. Les méthodes `get…` renvoient `null`
/// quand rien n'est en cache ; toute erreur Isar devient une
/// [CacheException].
abstract interface class MovieLocalDataSource {
  Future<void> cacheMovieList({
    required String category,
    required int page,
    required int totalPages,
    required List<CachedMovie> movies,
  });

  Future<CachedMoviePage?> getMovieList({
    required String category,
    required int page,
  });

  Future<void> cacheSearch({
    required String query,
    required int page,
    required int totalPages,
    required int totalResults,
    required List<CachedMovie> movies,
  });

  Future<CachedMoviePage?> getSearch({
    required String query,
    required int page,
  });

  /// Requêtes déjà recherchées (normalisées), les plus récentes d'abord.
  Future<List<String>> getRecentQueries({int limit = 8});

  Future<void> cacheMovieDetails({
    required CachedMovie movie,
    required CachedMovieDetails details,
    required List<CachedMovie> similar,
  });

  Future<CachedMovieFull?> getMovieDetails(int movieId);

  Future<void> cacheGenres(List<CachedGenre> genres);

  Future<List<CachedGenre>> getGenres();

  /// Nombre de films en cache (écran Profil).
  Future<int> countCachedMovies();

  /// Date de la dernière mise à jour du cache (écran Profil).
  Future<DateTime?> lastUpdate();
}

class IsarMovieLocalDataSource implements MovieLocalDataSource {
  IsarMovieLocalDataSource(this._isar);

  final Isar _isar;

  @override
  Future<void> cacheMovieList({
    required String category,
    required int page,
    required int totalPages,
    required List<CachedMovie> movies,
  }) => _guard(
    () => _isar.writeTxn(() async {
      await _isar.cachedMovies.putAll(movies);
      await _isar.cachedMovieLists.putByKey(
        CachedMovieList()
          ..key = CachedMovieList.keyFor(category, page)
          ..category = category
          ..page = page
          ..totalPages = totalPages
          ..movieIds = movies.map((m) => m.id).toList()
          ..cachedAt = DateTime.now(),
      );
    }),
  );

  @override
  Future<CachedMoviePage?> getMovieList({
    required String category,
    required int page,
  }) => _guard(() async {
    final list = await _isar.cachedMovieLists.getByKey(
      CachedMovieList.keyFor(category, page),
    );
    if (list == null) return null;
    return (
      movies: await _moviesByIds(list.movieIds),
      page: list.page,
      totalPages: list.totalPages,
      totalResults: list.movieIds.length,
      cachedAt: list.cachedAt,
    );
  });

  @override
  Future<void> cacheSearch({
    required String query,
    required int page,
    required int totalPages,
    required int totalResults,
    required List<CachedMovie> movies,
  }) => _guard(
    () => _isar.writeTxn(() async {
      await _isar.cachedMovies.putAll(movies);
      await _isar.cachedSearchs.putByKey(
        CachedSearch()
          ..key = CachedSearch.keyFor(query, page)
          ..query = CachedSearch.normalize(query)
          ..page = page
          ..totalPages = totalPages
          ..totalResults = totalResults
          ..movieIds = movies.map((m) => m.id).toList()
          ..cachedAt = DateTime.now(),
      );
    }),
  );

  @override
  Future<CachedMoviePage?> getSearch({
    required String query,
    required int page,
  }) => _guard(() async {
    final search = await _isar.cachedSearchs.getByKey(
      CachedSearch.keyFor(query, page),
    );
    if (search == null) return null;
    return (
      movies: await _moviesByIds(search.movieIds),
      page: search.page,
      totalPages: search.totalPages,
      totalResults: search.totalResults,
      cachedAt: search.cachedAt,
    );
  });

  @override
  Future<List<String>> getRecentQueries({int limit = 8}) => _guard(() async {
    // Seule la première page d'une recherche en marque l'usage récent.
    final searches = await _isar.cachedSearchs
        .filter()
        .pageEqualTo(1)
        .and()
        .totalResultsGreaterThan(0)
        .sortByCachedAtDesc()
        .limit(limit)
        .findAll();
    return [for (final s in searches) s.query];
  });

  @override
  Future<void> cacheMovieDetails({
    required CachedMovie movie,
    required CachedMovieDetails details,
    required List<CachedMovie> similar,
  }) => _guard(
    () => _isar.writeTxn(() async {
      await _isar.cachedMovies.putAll([movie, ...similar]);
      await _isar.cachedMovieDetails.put(
        details
          ..id = movie.id
          ..similarIds = similar.map((m) => m.id).toList(),
      );
    }),
  );

  @override
  Future<CachedMovieFull?> getMovieDetails(int movieId) => _guard(() async {
    final movie = await _isar.cachedMovies.get(movieId);
    final details = await _isar.cachedMovieDetails.get(movieId);
    if (movie == null || details == null) return null;
    return (
      movie: movie,
      details: details,
      similar: await _moviesByIds(details.similarIds),
    );
  });

  @override
  Future<void> cacheGenres(List<CachedGenre> genres) => _guard(
    () => _isar.writeTxn(() async {
      await _isar.cachedGenres.clear();
      await _isar.cachedGenres.putAll(genres);
    }),
  );

  @override
  Future<List<CachedGenre>> getGenres() =>
      _guard(() => _isar.cachedGenres.where().findAll());

  @override
  Future<int> countCachedMovies() => _guard(() => _isar.cachedMovies.count());

  @override
  Future<DateTime?> lastUpdate() => _guard(
    () => _isar.cachedMovies
        .where()
        .sortByCachedAtDesc()
        .cachedAtProperty()
        .findFirst(),
  );

  /// Récupère les films dans l'ordre des ids, en ignorant ceux purgés.
  Future<List<CachedMovie>> _moviesByIds(List<int> ids) async {
    final movies = await _isar.cachedMovies.getAll(ids);
    return movies.nonNulls.toList();
  }

  Future<T> _guard<T>(Future<T> Function() body) async {
    try {
      return await body();
    } on IsarError catch (e) {
      throw CacheException(e.message);
    }
  }
}
