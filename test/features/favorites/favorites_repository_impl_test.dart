import 'package:flutter_app_production_ready/core/error/exceptions.dart';
import 'package:flutter_app_production_ready/core/error/failures.dart';
import 'package:flutter_app_production_ready/core/result/result.dart';
import 'package:flutter_app_production_ready/features/favorites/data/local/favorites_local_data_source.dart';
import 'package:flutter_app_production_ready/features/favorites/data/local/models/favorite_movie.dart';
import 'package:flutter_app_production_ready/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:flutter_app_production_ready/features/favorites/domain/entities/favorite.dart';
import 'package:flutter_app_production_ready/features/favorites/domain/usecases/favorite_usecases.dart';
import 'package:flutter_app_production_ready/features/movies/domain/entities/movie.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLocal extends Mock implements FavoritesLocalDataSource {}

void main() {
  late MockLocal local;
  String? userId;
  late FavoritesRepositoryImpl repository;

  final favorite = Favorite(
    movieId: 42,
    title: 'Le Dernier Projectionniste',
    releaseDate: DateTime(2024, 3, 12),
    voteAverage: 8.2,
    genres: const ['Drame'],
    addedAt: DateTime(2026, 9, 26),
  );

  setUpAll(() => registerFallbackValue(FavoriteMovie()));

  setUp(() {
    local = MockLocal();
    userId = 'awa';
    repository = FavoritesRepositoryImpl(
      local: local,
      currentUserId: () => userId,
    );
    when(() => local.addFavorite(any())).thenAnswer((_) async {});
    when(() => local.removeFavorite(any(), any())).thenAnswer((_) async {});
  });

  test(
    'ajout : enregistré pour l’utilisateur connecté, données complètes',
    () async {
      final result = await repository.addFavorite(favorite);

      expect(result, isA<Success<void>>());
      final saved =
          verify(() => local.addFavorite(captureAny())).captured.single
              as FavoriteMovie;
      expect(saved.ownerId, 'awa');
      expect(saved.movieId, 42);
      expect(saved.releaseDate, '2024-03-12');
      expect(saved.genreNames, ['Drame']);
      // L'aller-retour entité → Isar → entité est sans perte.
      expect(saved.toEntity(), favorite);
    },
  );

  test('suppression : ciblée sur l’utilisateur connecté', () async {
    await repository.removeFavorite(42);

    verify(() => local.removeFavorite('awa', 42)).called(1);
  });

  test('sans session : UnauthorizedFailure, rien n’est écrit', () async {
    userId = null;

    final result = await repository.addFavorite(favorite);

    expect((result as Error).failure, isA<UnauthorizedFailure>());
    verifyNever(() => local.addFavorite(any()));
  });

  test('erreur Isar à l’écriture : CacheFailure', () async {
    when(() => local.addFavorite(any()))
        .thenThrow(const CacheException('disque plein'));

    final result = await repository.addFavorite(favorite);

    expect((result as Error).failure, isA<CacheFailure>());
  });

  test(
    'flux : modèles Isar convertis, erreurs converties en Failure',
    () async {
      when(() => local.watchFavorites('awa')).thenAnswer(
        (_) => Stream.fromIterable([
          [FavoriteMovieX.fromEntity(favorite, 'awa')],
        ]).followedByError(const CacheException()),
      );

      final events = <Object>[];
      await repository
          .watchFavorites()
          .handleError(events.add)
          .forEach(events.add);

      expect(events.first, [favorite]);
      expect(events.last, isA<CacheFailure>());
    },
  );

  group('ToggleFavorite', () {
    const movie = Movie(id: 42, title: 'Le Dernier Projectionniste');

    test('pas encore favori → ajout, nouvel état true', () async {
      final result = await ToggleFavorite(repository)(
        movie,
        isFavorite: false,
        genres: const ['Drame'],
      );

      expect(result.dataOrNull, isTrue);
      verify(() => local.addFavorite(any())).called(1);
    });

    test('déjà favori → suppression, nouvel état false', () async {
      final result = await ToggleFavorite(repository)(movie, isFavorite: true);

      expect(result.dataOrNull, isFalse);
      verify(() => local.removeFavorite('awa', 42)).called(1);
    });
  });
}

extension<T> on Stream<T> {
  Stream<T> followedByError(Object error) async* {
    yield* this;
    throw error;
  }
}
