import 'package:flutter_app_production_ready/core/error/exceptions.dart';
import 'package:flutter_app_production_ready/core/error/failures.dart';
import 'package:flutter_app_production_ready/core/network/network_info.dart';
import 'package:flutter_app_production_ready/core/result/result.dart';
import 'package:flutter_app_production_ready/features/favorites/data/local/favorites_local_data_source.dart';
import 'package:flutter_app_production_ready/features/movies/data/local/movie_local_data_source.dart';
import 'package:flutter_app_production_ready/features/profile/data/datasources/profile_data_sources.dart';
import 'package:flutter_app_production_ready/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:flutter_app_production_ready/features/profile/domain/entities/profile_entities.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemote extends Mock implements ProfileRemoteDataSource {}

class MockSession extends Mock implements SessionDataSource {}

class MockMovies extends Mock implements MovieLocalDataSource {}

class MockFavorites extends Mock implements FavoritesLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late MockRemote remote;
  late MockSession session;
  late MockMovies movies;
  late MockFavorites favorites;
  late MockNetworkInfo network;
  late ProfileRepositoryImpl repository;

  final remoteProfile = UserProfile(
    id: 'awa',
    email: 'awa.konan@exemple.com',
    fullName: 'Awa Konan',
    createdAt: DateTime(2026, 3, 2),
    provider: 'email',
  );
  const localProfile = UserProfile(id: 'awa', email: 'awa.konan@exemple.com');

  setUp(() {
    remote = MockRemote();
    session = MockSession();
    movies = MockMovies();
    favorites = MockFavorites();
    network = MockNetworkInfo();
    repository = ProfileRepositoryImpl(
      remote: remote,
      session: session,
      movies: movies,
      favorites: favorites,
      networkInfo: network,
    );
    when(() => session.currentUser).thenReturn(localProfile);
  });

  test('en ligne : compte lu via l’API Supabase', () async {
    when(() => network.isConnected).thenAnswer((_) async => true);
    when(() => remote.getUser()).thenAnswer((_) async => remoteProfile);

    final result = await repository.getProfile();

    expect((result as Success).fromCache, isFalse);
    expect(result.dataOrNull, remoteProfile);
  });

  test(
    'session expirée (401 après échec du refresh) : pas de repli local',
    () async {
      when(() => network.isConnected).thenAnswer((_) async => true);
      when(() => remote.getUser()).thenThrow(const UnauthorizedException());

      final result = await repository.getProfile();

      final failure = (result as Error).failure;
      expect(failure, isA<UnauthorizedFailure>());
      expect(failure.message, 'Votre session a expiré.');
    },
  );

  test('hors ligne : compte de la session locale', () async {
    when(() => network.isConnected).thenAnswer((_) async => false);

    final result = await repository.getProfile();

    expect((result as Success).fromCache, isTrue);
    expect(result.dataOrNull, localProfile);
    verifyNever(() => remote.getUser());
  });

  test('erreur serveur : repli sur la session locale', () async {
    when(() => network.isConnected).thenAnswer((_) async => true);
    when(() => remote.getUser())
        .thenThrow(const ServerException(statusCode: 503));

    final result = await repository.getProfile();

    expect(result.dataOrNull, localProfile);
  });

  test(
    'statistiques hors ligne : cache films + favoris de l’utilisateur',
    () async {
      final lastUpdate = DateTime(2026, 9, 26, 10);
      when(() => movies.countCachedMovies()).thenAnswer((_) async => 128);
      when(() => movies.lastUpdate()).thenAnswer((_) async => lastUpdate);
      when(() => favorites.countFavorites('awa')).thenAnswer((_) async => 4);

      final result = await repository.getOfflineStats();

      expect(
        result.dataOrNull,
        OfflineStats(cachedMovies: 128, favorites: 4, lastUpdate: lastUpdate),
      );
    },
  );
}
