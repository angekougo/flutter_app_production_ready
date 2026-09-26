import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/repository/network_first.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/genre.dart';
import '../../domain/entities/movie_category.dart';
import '../../domain/entities/movie_details.dart';
import '../../domain/entities/paginated_movies.dart';
import '../../domain/repositories/movie_repository.dart';
import '../local/movie_local_data_source.dart';
import '../remote/models/genre_model.dart';
import '../remote/models/movie_details_model.dart';
import '../remote/models/movie_model.dart';
import '../remote/movie_remote_data_source.dart';

class MovieRepositoryImpl implements MovieRepository {
  MovieRepositoryImpl({
    required this._remote,
    required this._local,
    required this._networkInfo,
  });

  final MovieRemoteDataSource _remote;
  final MovieLocalDataSource _local;
  final NetworkInfo _networkInfo;

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
  Future<Result<PaginatedMovies>> getMoviesByCategory(
    MovieCategory category, {
    int page = 1,
  }) => networkFirst(
    networkInfo: _networkInfo,
    fetchRemote: () async {
      final remotePage = await _remote.getMovies(category, page: page);
      await saveQuietly(
        () => _local.cacheMovieList(
          category: category.key,
          page: page,
          totalPages: remotePage.totalPages,
          movies: [for (final m in remotePage.results) m.toCached()],
        ),
      );
      return remotePage.toEntity();
    },
    readCache: () async {
      final cached = await _local.getMovieList(
        category: category.key,
        page: page,
      );
      if (cached == null) return null;
      return (data: _toPaginated(cached), cachedAt: cached.cachedAt);
    },
  );

  @override
  Future<Result<PaginatedMovies>> searchMovies(String query, {int page = 1}) =>
      networkFirst(
        networkInfo: _networkInfo,
        fetchRemote: () async {
          final remotePage = await _remote.searchMovies(query, page: page);
          await saveQuietly(
            () => _local.cacheSearch(
              query: query,
              page: page,
              totalPages: remotePage.totalPages,
              totalResults: remotePage.totalResults,
              movies: [for (final m in remotePage.results) m.toCached()],
            ),
          );
          return remotePage.toEntity();
        },
        readCache: () async {
          final cached = await _local.getSearch(query: query, page: page);
          if (cached == null) return null;
          return (data: _toPaginated(cached), cachedAt: cached.cachedAt);
        },
      );

  @override
  Future<Result<List<String>>> getRecentSearches({int limit = 8}) async {
    try {
      return Success(await _local.getRecentQueries(limit: limit));
    } on AppException catch (e) {
      return Error(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<MovieDetails>> getMovieDetails(int movieId) => networkFirst(
    networkInfo: _networkInfo,
    fetchRemote: () async {
      final details = await _remote.getMovieDetails(movieId);
      await saveQuietly(
        () => _local.cacheMovieDetails(
          movie: details.toCachedMovie(),
          details: details.toCachedDetails(),
          similar: details.toCachedSimilar(),
        ),
      );
      return details.toEntity();
    },
    readCache: () async {
      final cached = await _local.getMovieDetails(movieId);
      if (cached == null) return null;
      return (
        data: MovieDetailsModel.fromCached(cached).toEntity(),
        cachedAt: cached.details.cachedAt,
      );
    },
  );

  @override
  Future<Result<List<Genre>>> getGenres() => networkFirst(
    networkInfo: _networkInfo,
    fetchRemote: () async {
      final genres = await _remote.getGenres();
      await saveQuietly(
        () => _local.cacheGenres([for (final g in genres) g.toCached()]),
      );
      return [for (final g in genres) g.toEntity()];
    },
    readCache: () async {
      final cached = await _local.getGenres();
      if (cached.isEmpty) return null;
      return (
        data: [for (final g in cached) GenreModel.fromCached(g).toEntity()],
        cachedAt: cached.first.cachedAt,
      );
    },
  );

  static PaginatedMovies _toPaginated(CachedMoviePage cached) =>
      PaginatedMovies(
        movies: [
          for (final m in cached.movies) MovieModel.fromCached(m).toEntity(),
        ],
        page: cached.page,
        totalPages: cached.totalPages,
        totalResults: cached.totalResults,
      );
}
