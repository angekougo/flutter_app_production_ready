import 'package:flutter_app_production_ready/features/movies/data/local/models/cached_movie.dart';
import 'package:flutter_app_production_ready/features/movies/data/local/models/cached_movie_details.dart';
import 'package:flutter_app_production_ready/features/movies/data/local/movie_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';

import '../../helpers/isar_test_helper.dart';

CachedMovie movie(int id, {String? title}) => CachedMovie()
  ..id = id
  ..title = title ?? 'Film $id'
  ..voteAverage = 7.5
  ..genreIds = [18]
  ..cachedAt = DateTime.now();

void main() {
  late Isar isar;
  late IsarMovieLocalDataSource local;

  setUp(() async {
    isar = await openTestIsar();
    local = IsarMovieLocalDataSource(isar);
  });

  tearDown(() => closeTestIsar(isar));

  test('liste : conserve l’ordre TMDB et la pagination', () async {
    await local.cacheMovieList(
      category: 'popular',
      page: 1,
      totalPages: 12,
      movies: [movie(3), movie(1), movie(2)],
    );

    final page = await local.getMovieList(category: 'popular', page: 1);

    expect(page!.movies.map((m) => m.id), [3, 1, 2]);
    expect(page.totalPages, 12);
    expect(await local.getMovieList(category: 'popular', page: 2), isNull);
    expect(await local.getMovieList(category: 'trending', page: 1), isNull);
  });

  test('un film partagé entre deux listes n’est stocké qu’une fois', () async {
    await local.cacheMovieList(
      category: 'popular',
      page: 1,
      totalPages: 1,
      movies: [movie(1), movie(2)],
    );
    await local.cacheMovieList(
      category: 'trending',
      page: 1,
      totalPages: 1,
      movies: [
        movie(2, title: 'Titre mis à jour'),
        movie(3),
      ],
    );

    expect(await local.countCachedMovies(), 3);
    final popular = await local.getMovieList(category: 'popular', page: 1);
    expect(popular!.movies.last.title, 'Titre mis à jour');
  });

  test('recherche : insensible à la casse et aux espaces', () async {
    await local.cacheSearch(
      query: '  La Nuit ',
      page: 1,
      totalPages: 2,
      totalResults: 24,
      movies: [movie(10)],
    );

    final page = await local.getSearch(query: 'la   nuit', page: 1);

    expect(page!.totalResults, 24);
    expect(page.movies.single.id, 10);
  });

  test('détails : casting et films similaires', () async {
    await local.cacheMovieDetails(
      movie: movie(42),
      details: CachedMovieDetails()
        ..runtime = 118
        ..genreNames = ['Drame']
        ..cast = [
          CachedCastMember(id: 7, name: 'Camille Serre', character: 'Lucie'),
        ]
        ..cachedAt = DateTime.now(),
      similar: [movie(43), movie(44)],
    );

    final full = await local.getMovieDetails(42);

    expect(full!.details.runtime, 118);
    expect(full.details.cast.single.name, 'Camille Serre');
    expect(full.similar.map((m) => m.id), [43, 44]);
    expect(await local.getMovieDetails(99), isNull);
  });

  test(
    'recherches récentes : plus récentes d’abord, sans résultats vides',
    () async {
      Future<void> search(String q, int results) => local.cacheSearch(
        query: q,
        page: 1,
        totalPages: 1,
        totalResults: results,
        movies: [if (results > 0) movie(results)],
      );

      await search('Dune', 3);
      await Future<void>.delayed(const Duration(milliseconds: 5));
      await search('zzqx', 0);
      await Future<void>.delayed(const Duration(milliseconds: 5));
      await search('La Nuit', 5);

      expect(await local.getRecentQueries(), ['la nuit', 'dune']);
      expect(await local.getRecentQueries(limit: 1), ['la nuit']);
    },
  );
}
