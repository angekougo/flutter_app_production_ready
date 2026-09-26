import 'package:flutter_app_production_ready/core/error/exceptions.dart';
import 'package:flutter_app_production_ready/core/error/failures.dart';
import 'package:flutter_app_production_ready/core/network/network_info.dart';
import 'package:flutter_app_production_ready/core/result/result.dart';
import 'package:flutter_app_production_ready/features/movies/data/local/models/cached_genre.dart';
import 'package:flutter_app_production_ready/features/movies/data/local/models/cached_movie.dart';
import 'package:flutter_app_production_ready/features/movies/data/local/movie_local_data_source.dart';
import 'package:flutter_app_production_ready/features/movies/data/remote/models/genre_model.dart';
import 'package:flutter_app_production_ready/features/movies/data/remote/models/movie_model.dart';
import 'package:flutter_app_production_ready/features/movies/data/remote/models/movie_page_model.dart';
import 'package:flutter_app_production_ready/features/movies/data/remote/movie_remote_data_source.dart';
import 'package:flutter_app_production_ready/features/movies/data/repositories/movie_repository_impl.dart';
import 'package:flutter_app_production_ready/features/movies/domain/entities/movie_category.dart';
import 'package:flutter_app_production_ready/features/movies/domain/entities/paginated_movies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemote extends Mock implements MovieRemoteDataSource {}

class MockLocal extends Mock implements MovieLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

MovieModel movieModel(int id) => MovieModel(
  id: id,
  title: 'Film $id',
  releaseDate: '2024-03-12',
  voteAverage: 8.2,
  voteCount: 120,
  genreIds: const [18],
);

MoviePageModel pageOf(List<int> ids, {int totalPages = 3}) => MoviePageModel(
  page: 1,
  results: [for (final id in ids) movieModel(id)],
  totalPages: totalPages,
  totalResults: ids.length * totalPages,
);

void main() {
  late MockRemote remote;
  late MockLocal local;
  late MockNetworkInfo network;
  late MovieRepositoryImpl repository;

  final cachedAt = DateTime(2026, 9, 26, 10);

  setUpAll(() => registerFallbackValue(MovieCategory.popular));

  setUp(() {
    remote = MockRemote();
    local = MockLocal();
    network = MockNetworkInfo();
    repository = MovieRepositoryImpl(
      remote: remote,
      local: local,
      networkInfo: network,
    );

    when(
      () => local.cacheMovieList(
        category: any(named: 'category'),
        page: any(named: 'page'),
        totalPages: any(named: 'totalPages'),
        movies: any(named: 'movies'),
      ),
    ).thenAnswer((_) async {});
  });

  void online() =>
      when(() => network.isConnected).thenAnswer((_) async => true);
  void offline() =>
      when(() => network.isConnected).thenAnswer((_) async => false);

  void cacheReturns(CachedMoviePage? page) => when(
    () => local.getMovieList(
      category: any(named: 'category'),
      page: any(named: 'page'),
    ),
  ).thenAnswer((_) async => page);

  CachedMoviePage cachedPage(List<int> ids) => (
    movies: [for (final id in ids) movieModel(id).toCached(cachedAt: cachedAt)],
    page: 1,
    totalPages: 3,
    totalResults: ids.length,
    cachedAt: cachedAt,
  );

  group('getPopularMovies', () {
    test('en ligne : renvoie les films TMDB et met à jour le cache', () async {
      online();
      when(() => remote.getMovies(MovieCategory.popular, page: 1))
          .thenAnswer((_) async => pageOf([1, 2, 3]));

      final result = await repository.getPopularMovies();

      final success = result as Success<PaginatedMovies>;
      expect(success.fromCache, isFalse);
      expect(success.data.movies.map((m) => m.id), [1, 2, 3]);
      expect(success.data.movies.first.year, 2024);

      final captured = verify(
        () => local.cacheMovieList(
          category: 'popular',
          page: 1,
          totalPages: 3,
          movies: captureAny(named: 'movies'),
        ),
      ).captured;
      final cachedMovies = captured.single as List<CachedMovie>;
      expect(cachedMovies.map((m) => m.id), [1, 2, 3]);
    });

    test(
      'une erreur d’écriture du cache ne masque pas les données fraîches',
      () async {
        online();
        when(() => remote.getMovies(MovieCategory.popular, page: 1))
            .thenAnswer((_) async => pageOf([1]));
        when(
          () => local.cacheMovieList(
            category: any(named: 'category'),
            page: any(named: 'page'),
            totalPages: any(named: 'totalPages'),
            movies: any(named: 'movies'),
          ),
        ).thenThrow(const CacheException('disque plein'));

        final result = await repository.getPopularMovies();

        expect(result.dataOrNull!.movies.single.id, 1);
      },
    );
  });

  group('getTrendingMovies', () {
    test('en ligne : interroge la catégorie « trending »', () async {
      online();
      when(() => remote.getMovies(MovieCategory.trending, page: 2))
          .thenAnswer((_) async => pageOf([7]));

      final result = await repository.getTrendingMovies(page: 2);

      expect(result.dataOrNull!.movies.single.id, 7);
      verify(
        () => local.cacheMovieList(
          category: 'trending',
          page: 2,
          totalPages: any(named: 'totalPages'),
          movies: any(named: 'movies'),
        ),
      ).called(1);
    });
  });

  group('mode hors ligne (fallback Isar)', () {
    test('sans réseau : sert le cache sans appeler TMDB', () async {
      offline();
      cacheReturns(cachedPage([4, 5]));

      final result = await repository.getNowPlayingMovies();

      final success = result as Success<PaginatedMovies>;
      expect(success.fromCache, isTrue);
      expect(success.cachedAt, cachedAt);
      expect(success.data.movies.map((m) => m.id), [4, 5]);
      verifyNever(() => remote.getMovies(any(), page: any(named: 'page')));
    });

    test('TMDB injoignable malgré le Wi-Fi : bascule sur le cache', () async {
      online();
      when(() => remote.getMovies(MovieCategory.popular, page: 1))
          .thenThrow(const NetworkException('timeout'));
      cacheReturns(cachedPage([9]));

      final result = await repository.getPopularMovies();

      expect((result as Success).fromCache, isTrue);
      expect(result.dataOrNull!.movies.single.id, 9);
    });

    test(
      'sans réseau ni cache : CacheFailure avec le message attendu',
      () async {
        offline();
        cacheReturns(null);

        final result = await repository.getPopularMovies();

        final failure = (result as Error).failure;
        expect(failure, isA<CacheFailure>());
        expect(
          failure.message,
          'Impossible de charger les données. '
          'Aucune donnée hors ligne n’est disponible.',
        );
      },
    );
  });

  group('erreurs HTTP', () {
    test('500 sans cache : ServerFailure', () async {
      online();
      when(() => remote.getMovies(MovieCategory.popular, page: 1))
          .thenThrow(const ServerException(statusCode: 500));
      cacheReturns(null);

      final result = await repository.getPopularMovies();

      expect((result as Error).failure, isA<ServerFailure>());
    });

    test(
      '401 (jeton TMDB invalide) sans cache : UnauthorizedFailure',
      () async {
        online();
        when(() => remote.getMovies(MovieCategory.trending, page: 1))
            .thenThrow(const UnauthorizedException());
        cacheReturns(null);

        final result = await repository.getTrendingMovies();

        expect((result as Error).failure, isA<UnauthorizedFailure>());
      },
    );

    test('500 avec cache : les données en cache restent affichées', () async {
      online();
      when(() => remote.getMovies(MovieCategory.popular, page: 1))
          .thenThrow(const ServerException(statusCode: 503));
      cacheReturns(cachedPage([1]));

      final result = await repository.getPopularMovies();

      expect((result as Success).fromCache, isTrue);
    });
  });

  group('getGenres', () {
    test('hors ligne : genres depuis le cache', () async {
      offline();
      when(() => local.getGenres()).thenAnswer(
        (_) async => [
          const GenreModel(id: 18, name: 'Drame').toCached(),
          CachedGenre()
            ..id = 53
            ..name = 'Thriller'
            ..cachedAt = cachedAt,
        ],
      );

      final result = await repository.getGenres();

      expect(result.dataOrNull!.map((g) => g.name), ['Drame', 'Thriller']);
    });
  });

  group('searchMovies', () {
    setUp(() {
      when(
        () => local.cacheSearch(
          query: any(named: 'query'),
          page: any(named: 'page'),
          totalPages: any(named: 'totalPages'),
          totalResults: any(named: 'totalResults'),
          movies: any(named: 'movies'),
        ),
      ).thenAnswer((_) async {});
    });

    test('en ligne : résultats TMDB mis en cache pour la requête', () async {
      online();
      when(() => remote.searchMovies('nuit', page: 1))
          .thenAnswer((_) async => pageOf([11, 12], totalPages: 2));

      final result = await repository.searchMovies('nuit');

      final data = result.dataOrNull!;
      expect(data.movies.map((m) => m.id), [11, 12]);
      expect(data.totalResults, 4);
      expect(data.hasMore, isTrue);
      verify(
        () => local.cacheSearch(
          query: 'nuit',
          page: 1,
          totalPages: 2,
          totalResults: 4,
          movies: any(named: 'movies'),
        ),
      ).called(1);
    });

    test('hors ligne : sert une recherche déjà effectuée', () async {
      offline();
      when(() => local.getSearch(query: 'Nuit', page: 1))
          .thenAnswer((_) async => cachedPage([11]));

      final result = await repository.searchMovies('Nuit');

      expect((result as Success).fromCache, isTrue);
      expect(result.dataOrNull!.movies.single.id, 11);
      verifyNever(() => remote.searchMovies(any(), page: any(named: 'page')));
    });

    test('hors ligne, recherche jamais faite : CacheFailure', () async {
      offline();
      when(() => local.getSearch(query: 'inconnu', page: 1))
          .thenAnswer((_) async => null);

      final result = await repository.searchMovies('inconnu');

      expect((result as Error).failure, isA<CacheFailure>());
    });
  });

  group('getRecentSearches', () {
    test('lit les requêtes récentes depuis Isar', () async {
      when(() => local.getRecentQueries(limit: 5))
          .thenAnswer((_) async => ['nuit', 'dune']);

      final result = await repository.getRecentSearches(limit: 5);

      expect(result.dataOrNull, ['nuit', 'dune']);
    });

    test('erreur Isar : CacheFailure', () async {
      when(() => local.getRecentQueries(limit: any(named: 'limit')))
          .thenThrow(const CacheException());

      final result = await repository.getRecentSearches();

      expect((result as Error).failure, isA<CacheFailure>());
    });
  });
}
