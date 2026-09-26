import 'package:flutter/material.dart';
import 'package:flutter_app_production_ready/core/error/failures.dart';
import 'package:flutter_app_production_ready/core/result/result.dart';
import 'package:flutter_app_production_ready/features/actors/domain/entities/actor_details.dart';
import 'package:flutter_app_production_ready/features/actors/domain/repositories/actor_repository.dart';
import 'package:flutter_app_production_ready/features/actors/presentation/pages/actor_details_page.dart';
import 'package:flutter_app_production_ready/features/actors/presentation/providers/actor_providers.dart';
import 'package:flutter_app_production_ready/features/movies/domain/entities/movie.dart';
import 'package:flutter_app_production_ready/features/movies/domain/entities/movie_details.dart';
import 'package:flutter_app_production_ready/features/movies/presentation/pages/movie_details_page.dart';
import 'package:flutter_app_production_ready/features/movies/presentation/providers/movie_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../helpers/fake_movie_repository.dart';
import '../../helpers/finders.dart';
import '../../helpers/test_app.dart';

/// Simule un bug imprévu (erreur qui n'est pas un Failure).
class _BuggyMovieRepository extends FakeMovieRepository {
  @override
  Future<Result<MovieDetails>> getMovieDetails(int movieId) =>
      Future.error(StateError('bug'));
}

class _FakeActorRepository implements ActorRepository {
  _FakeActorRepository(this.result);
  final Result<ActorDetails> result;

  @override
  Future<Result<ActorDetails>> getActorDetails(int actorId) async => result;
}

final projectionniste = MovieDetails(
  movie: Movie(
    id: 42,
    title: 'Le Dernier Projectionniste',
    originalTitle: 'The Last Projectionist',
    overview: 'Dans un cinéma de quartier promis à la démolition…',
    releaseDate: DateTime(2024, 3, 12),
    voteAverage: 8.2,
    voteCount: 900,
    popularity: 91.43,
  ),
  runtime: 118,
  genres: const ['Comédie dramatique', 'Drame'],
  cast: const [
    CastMember(id: 7, name: 'Camille Serre', character: 'Lucie'),
    CastMember(id: 8, name: 'Yves Bamba', character: 'Henri'),
  ],
  similar: const [Movie(id: 43, title: 'Les Heures Claires')],
);

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  Future<void> pump(
    WidgetTester tester,
    Widget page, {
    FakeMovieRepository? movies,
    ActorRepository? actors,
  }) async {
    tester.view.physicalSize = const Size(1170, 4000);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        retry: (_, _) => null,
        overrides: [
          if (movies != null) movieRepositoryProvider.overrideWithValue(movies),
          if (actors != null) actorRepositoryProvider.overrideWithValue(actors),
        ],
        child: testApp(page),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('Fiche film', () {
    testWidgets('titre, bandeau, genres, casting et similaires', (
      tester,
    ) async {
      await pump(
        tester,
        const MovieDetailsPage(movieId: 42),
        movies: FakeMovieRepository()..details[42] = projectionniste,
      );

      expect(find.text('The Last Projectionist'), findsOneWidget);
      expect(find.text('12.03.24'), findsOneWidget);
      expect(find.text('1H58'), findsOneWidget);
      expect(findStarText('★ 8,2'), findsOneWidget);
      expect(find.text('91,4'), findsOneWidget);
      expect(find.text('Comédie dramatique'), findsOneWidget);
      expect(find.text('Ajouter aux favoris'), findsOneWidget);
      expect(find.text('Camille Serre'), findsOneWidget);
      expect(find.text('Lucie'), findsOneWidget);
      expect(find.text('Films similaires'), findsOneWidget);
    });

    testWidgets('film inexistant : « Film introuvable. »', (tester) async {
      await pump(
        tester,
        const MovieDetailsPage(movieId: 1),
        movies: FakeMovieRepository(),
      );

      expect(find.text('Film introuvable.'), findsOneWidget);
      expect(find.text('Réessayer'), findsNothing);
    });

    testWidgets('hors ligne jamais consultée : message dédié', (tester) async {
      await pump(
        tester,
        const MovieDetailsPage(movieId: 42),
        movies: FakeMovieRepository(failure: const CacheFailure()),
      );

      expect(find.text('Fiche indisponible hors connexion'), findsOneWidget);
    });
  });

  // Régression : une erreur imprévue affichait un chargement sans fin.
  testWidgets('erreur imprévue : écran d’erreur, pas de chargement infini', (
    tester,
  ) async {
    await pump(
      tester,
      const MovieDetailsPage(movieId: 42),
      movies: _BuggyMovieRepository(),
    );

    expect(find.text('Impossible de charger les données.'), findsOneWidget);
    expect(find.text('Réessayer'), findsOneWidget);
  });

  group('Fiche acteur', () {
    final camille = ActorDetails(
      id: 7,
      name: 'Camille Serre',
      biography: 'Formée au théâtre avant de passer devant la caméra.',
      birthday: DateTime(1988, 3, 14),
      placeOfBirth: 'Lyon, France',
      gender: ActorGender.female,
      knownForDepartment: 'Acting',
      credits: [
        ActorCredit(
          movieId: 42,
          title: 'Le Dernier Projectionniste',
          role: 'Lucie',
          releaseDate: DateTime(2024, 3, 12),
        ),
        const ActorCredit(movieId: 43, title: 'Grand Large', role: 'Maïa'),
      ],
    );

    testWidgets('identité, statistiques, biographie et filmographie', (
      tester,
    ) async {
      await pump(
        tester,
        const ActorDetailsPage(actorId: 7),
        actors: _FakeActorRepository(Success(camille)),
      );

      expect(find.text('CS'), findsOneWidget); // initiales sans photo
      expect(find.text('NÉE LE 14.03.1988 · LYON'), findsOneWidget);
      expect(find.text('CONNUE POUR'), findsOneWidget);
      expect(find.text('Interprétation'), findsOneWidget);
      expect(find.text('2 FILMS'), findsOneWidget);
      expect(find.text('2024 · LUCIE'), findsOneWidget);
      expect(find.text('MAÏA'), findsOneWidget);
    });

    testWidgets('acteur inexistant : « Acteur introuvable. »', (tester) async {
      await pump(
        tester,
        const ActorDetailsPage(actorId: 99),
        actors: _FakeActorRepository(
          const Error(NotFoundFailure(NotFoundResource.actor)),
        ),
      );

      expect(find.text('Acteur introuvable.'), findsOneWidget);
    });
  });
}
