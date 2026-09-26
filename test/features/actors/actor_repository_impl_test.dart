import 'package:flutter_app_production_ready/core/error/exceptions.dart';
import 'package:flutter_app_production_ready/core/error/failures.dart';
import 'package:flutter_app_production_ready/core/network/network_info.dart';
import 'package:flutter_app_production_ready/core/result/result.dart';
import 'package:flutter_app_production_ready/features/actors/data/local/actor_local_data_source.dart';
import 'package:flutter_app_production_ready/features/actors/data/local/models/cached_actor.dart';
import 'package:flutter_app_production_ready/features/actors/data/remote/actor_remote_data_source.dart';
import 'package:flutter_app_production_ready/features/actors/data/remote/models/actor_model.dart';
import 'package:flutter_app_production_ready/features/actors/data/repositories/actor_repository_impl.dart';
import 'package:flutter_app_production_ready/features/actors/domain/entities/actor_details.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemote extends Mock implements ActorRemoteDataSource {}

class MockLocal extends Mock implements ActorLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

Map<String, dynamic> personJson() => {
  'id': 7,
  'name': 'Camille Serre',
  'biography': 'Formée au théâtre avant de passer devant la caméra…',
  'birthday': '1988-03-14',
  'place_of_birth': 'Lyon, France',
  'gender': 1,
  'known_for_department': 'Acting',
  'movie_credits': {
    'cast': [
      {
        'id': 1,
        'title': 'Grand Large',
        'character': 'Maïa',
        'release_date': '2023-05-01',
      },
      {
        'id': 2,
        'title': 'Le Dernier Projectionniste',
        'character': 'Lucie',
        'release_date': '2024-03-12',
      },
      // Même film, second rôle : ne doit apparaître qu'une fois.
      {
        'id': 2,
        'title': 'Le Dernier Projectionniste',
        'character': 'Voix off',
        'release_date': '2024-03-12',
      },
      {'id': 3, 'title': 'Projet sans date', 'character': 'Élise'},
    ],
    'crew': [
      {
        'id': 4,
        'title': 'Court-métrage',
        'job': 'Director',
        'release_date': '2020-01-01',
      },
      {'id': 5, 'title': 'Un ami', 'job': 'Thanks'},
    ],
  },
};

void main() {
  late MockRemote remote;
  late MockLocal local;
  late MockNetworkInfo network;
  late ActorRepositoryImpl repository;

  setUpAll(() => registerFallbackValue(CachedActor()));

  setUp(() {
    remote = MockRemote();
    local = MockLocal();
    network = MockNetworkInfo();
    repository = ActorRepositoryImpl(
      remote: remote,
      local: local,
      networkInfo: network,
    );
    when(() => local.cacheActor(any())).thenAnswer((_) async {});
  });

  test(
    'filmographie : sans doublon, triée, postes traduits, sans « Thanks »',
    () {
      final actor = ActorModel.fromJson(personJson()).toEntity();

      expect(actor.gender, ActorGender.female);
      expect(actor.birthday, DateTime(1988, 3, 14));
      expect(actor.credits.map((c) => c.title), [
        'Le Dernier Projectionniste',
        'Grand Large',
        'Court-métrage',
        'Projet sans date',
      ]);
      expect(actor.credits.first.role, 'Lucie');
      expect(actor.credits[2].role, 'Réalisation');
    },
  );

  test('en ligne : fiche TMDB mise en cache', () async {
    when(() => network.isConnected).thenAnswer((_) async => true);
    when(() => remote.getActor(7))
        .thenAnswer((_) async => ActorModel.fromJson(personJson()));

    final result = await repository.getActorDetails(7);

    expect(result.dataOrNull!.name, 'Camille Serre');
    final cached =
        verify(() => local.cacheActor(captureAny())).captured.single
            as CachedActor;
    expect(cached.credits, hasLength(4));
  });

  test('hors ligne : fiche relue depuis Isar', () async {
    when(() => network.isConnected).thenAnswer((_) async => false);
    final model = ActorModel.fromJson(personJson());
    when(() => local.getActor(7)).thenAnswer((_) async => model.toCached());

    final result = await repository.getActorDetails(7);

    expect((result as Success).fromCache, isTrue);
    expect(result.dataOrNull, model.toEntity());
    verifyNever(() => remote.getActor(any()));
  });

  test('404 : « Acteur introuvable. »', () async {
    when(() => network.isConnected).thenAnswer((_) async => true);
    when(() => remote.getActor(99)).thenThrow(const NotFoundException());
    when(() => local.getActor(99)).thenAnswer((_) async => null);

    final result = await repository.getActorDetails(99);

    expect(
      (result as Error).failure,
      const NotFoundFailure('Acteur introuvable.'),
    );
  });
}
