import 'package:flutter_app_production_ready/core/error/exceptions.dart';
import 'package:flutter_app_production_ready/core/error/failures.dart';
import 'package:flutter_app_production_ready/core/network/network_info.dart';
import 'package:flutter_app_production_ready/core/result/result.dart';
import 'package:flutter_app_production_ready/features/movies/data/local/models/cached_movie.dart';
import 'package:flutter_app_production_ready/features/movies/data/local/models/cached_movie_details.dart';
import 'package:flutter_app_production_ready/features/movies/data/local/movie_local_data_source.dart';
import 'package:flutter_app_production_ready/features/movies/data/remote/models/movie_details_model.dart';
import 'package:flutter_app_production_ready/features/movies/data/remote/movie_remote_data_source.dart';
import 'package:flutter_app_production_ready/features/movies/data/repositories/movie_repository_impl.dart';
import 'package:flutter_app_production_ready/features/movies/domain/entities/movie_details.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemote extends Mock implements MovieRemoteDataSource {}

class MockLocal extends Mock implements MovieLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

/// JSON TMDB réduit de `/movie/42?append_to_response=credits,similar`.
Map<String, dynamic> tmdbDetailsJson() => {
  'id': 42,
  'title': 'Le Dernier Projectionniste',
  'original_title': 'The Last Projectionist',
  'overview': 'Un cinéma de quartier promis à la démolition…',
  'release_date': '2024-03-12',
  'runtime': 118,
  'vote_average': 8.2,
  'vote_count': 900,
  'popularity': 91.4,
  'genres': [
    {'id': 18, 'name': 'Drame'},
    {'id': 35, 'name': 'Comédie'},
  ],
  'credits': {
    'cast': [
      {'id': 8, 'name': 'Yves Bamba', 'character': 'Henri', 'order': 1},
      {'id': 7, 'name': 'Camille Serre', 'character': 'Lucie', 'order': 0},
    ],
  },
  'similar': {
    'results': [
      {
        'id': 43,
        'title': 'Les Heures Claires',
        'genre_ids': [18],
      },
    ],
  },
};

void main() {
  late MockRemote remote;
  late MockLocal local;
  late MockNetworkInfo network;
  late MovieRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(CachedMovie());
    registerFallbackValue(CachedMovieDetails());
  });

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
      () => local.cacheMovieDetails(
        movie: any(named: 'movie'),
        details: any(named: 'details'),
        similar: any(named: 'similar'),
      ),
    ).thenAnswer((_) async {});
  });

  test('en ligne : fiche complète, casting trié, cache mis à jour', () async {
    when(() => network.isConnected).thenAnswer((_) async => true);
    when(() => remote.getMovieDetails(42))
        .thenAnswer((_) async => MovieDetailsModel.fromJson(tmdbDetailsJson()));

    final result = await repository.getMovieDetails(42);

    final details = (result as Success<MovieDetails>).data;
    expect(details.movie.title, 'Le Dernier Projectionniste');
    expect(details.movie.originalTitle, 'The Last Projectionist');
    expect(details.movie.genreIds, [18, 35]);
    expect(details.runtime, 118);
    expect(details.genres, ['Drame', 'Comédie']);
    // Ordre du générique (champ `order`), pas l'ordre du JSON.
    expect(details.cast.map((c) => c.name), ['Camille Serre', 'Yves Bamba']);
    expect(details.similar.single.id, 43);

    final captured = verify(
      () => local.cacheMovieDetails(
        movie: captureAny(named: 'movie'),
        details: captureAny(named: 'details'),
        similar: captureAny(named: 'similar'),
      ),
    ).captured;
    expect((captured[0] as CachedMovie).id, 42);
    expect(
      (captured[1] as CachedMovieDetails).cast.first.name,
      'Camille Serre',
    );
    expect((captured[2] as List<CachedMovie>).single.id, 43);
  });

  test(
    'hors ligne : fiche relue depuis Isar, identique à l’originale',
    () async {
      when(() => network.isConnected).thenAnswer((_) async => false);
      final model = MovieDetailsModel.fromJson(tmdbDetailsJson());
      final cachedAt = DateTime(2026, 9, 26);
      when(() => local.getMovieDetails(42)).thenAnswer(
        (_) async => (
          movie: model.toCachedMovie(),
          details: model.toCachedDetails()..cachedAt = cachedAt,
          similar: model.toCachedSimilar(),
        ),
      );

      final result = await repository.getMovieDetails(42);

      final success = result as Success<MovieDetails>;
      expect(success.fromCache, isTrue);
      expect(success.cachedAt, cachedAt);
      expect(success.data, model.toEntity());
    },
  );

  test('404 TMDB sans cache : « Film introuvable. »', () async {
    when(() => network.isConnected).thenAnswer((_) async => true);
    when(() => remote.getMovieDetails(1)).thenThrow(const NotFoundException());
    when(() => local.getMovieDetails(1)).thenAnswer((_) async => null);

    final result = await repository.getMovieDetails(1);

    expect(
      (result as Error).failure,
      const NotFoundFailure(NotFoundResource.movie),
    );
  });
}
