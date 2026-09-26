import 'package:flutter/material.dart';
import 'package:flutter_app_production_ready/core/error/failures.dart';
import 'package:flutter_app_production_ready/core/network/network_info.dart';
import 'package:flutter_app_production_ready/core/providers/core_providers.dart';
import 'package:flutter_app_production_ready/features/auth/domain/entities/app_user.dart';
import 'package:flutter_app_production_ready/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter_app_production_ready/features/home/presentation/pages/home_page.dart';
import 'package:flutter_app_production_ready/features/movies/domain/entities/genre.dart';
import 'package:flutter_app_production_ready/features/movies/domain/entities/movie.dart';
import 'package:flutter_app_production_ready/features/movies/domain/entities/movie_category.dart';
import 'package:flutter_app_production_ready/features/movies/presentation/providers/movie_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../helpers/fake_movie_repository.dart';

class _StaticNetworkInfo implements NetworkInfo {
  @override
  Future<bool> get isConnected async => true;
  @override
  Stream<bool> get onStatusChange => const Stream.empty();
}

Movie movie(int id, String title, {List<int> genres = const [18]}) => Movie(
  id: id,
  title: title,
  releaseDate: DateTime(2024, 3, 12),
  voteAverage: 8.2,
  voteCount: 10,
  genreIds: genres,
);

final catalog = {
  MovieCategory.trending: [
    movie(1, 'Le Dernier Projectionniste'),
    movie(2, 'Marée Basse', genres: [53]),
  ],
  MovieCategory.popular: [movie(3, 'Les Heures Claires')],
  MovieCategory.nowPlaying: [
    movie(4, 'Orbite Lente', genres: [53]),
  ],
};

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  Future<void> pumpHome(WidgetTester tester, FakeMovieRepository repo) async {
    tester.view.physicalSize = const Size(1170, 3200);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        retry: (_, _) => null,
        overrides: [
          movieRepositoryProvider.overrideWithValue(repo),
          networkInfoProvider.overrideWithValue(_StaticNetworkInfo()),
          currentUserProvider.overrideWithValue(
            const AppUser(id: 'u', email: 'awa@x.com', fullName: 'Awa Konan'),
          ),
        ],
        child: const MaterialApp(home: HomePage()),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('en ligne : salutation, n°1 des tendances et sections', (
    tester,
  ) async {
    await pumpHome(
      tester,
      FakeMovieRepository(
        movies: catalog,
        genres: const [
          Genre(id: 18, name: 'Drame'),
          Genre(id: 53, name: 'Thriller'),
        ],
      ),
    );

    expect(find.textContaining(', AWA'), findsOneWidget);
    expect(find.text('N°1 DES TENDANCES'), findsOneWidget);
    expect(find.text('2024 · DRAME · ★ 8,2'), findsOneWidget);
    expect(find.text('Populaires'), findsOneWidget);
    expect(find.text('Nouveautés'), findsOneWidget);
    expect(
      find.text(
        'Hors connexion — affichage des dernières données disponibles.',
      ),
      findsNothing,
    );
  });

  testWidgets('le filtre de genre s’applique localement', (tester) async {
    await pumpHome(
      tester,
      FakeMovieRepository(
        movies: catalog,
        genres: const [
          Genre(id: 18, name: 'Drame'),
          Genre(id: 53, name: 'Thriller'),
        ],
      ),
    );

    await tester.tap(find.widgetWithText(ChoiceChip, 'Thriller'));
    await tester.pumpAndSettle();

    // « Marée Basse » (thriller) devient le n°1 des tendances.
    expect(find.text('Marée Basse'), findsOneWidget);
    expect(find.text('Le Dernier Projectionniste'), findsNothing);
    expect(
      find.text('Aucun film de ce genre dans cette sélection.'),
      // Populaires (drame) et Tendances (dont le n°1 est déjà mis en avant).
      findsNWidgets(2),
    );
  });

  testWidgets('hors ligne : bannière et sections « EN CACHE »', (tester) async {
    await pumpHome(
      tester,
      FakeMovieRepository(
        movies: catalog,
        fromCache: true,
        cachedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    );

    expect(
      find.text(
        'Hors connexion — affichage des dernières données disponibles.',
      ),
      findsOneWidget,
    );
    expect(find.text('MISES À JOUR IL Y A 2 H'), findsOneWidget);
    expect(find.text('EN CACHE'), findsNWidgets(3));
    expect(find.text('Tendances'), findsOneWidget);
    expect(find.text('N°1 DES TENDANCES'), findsNothing);
  });

  testWidgets('sans réseau ni cache : écran d’erreur et réessai', (
    tester,
  ) async {
    final repo = FakeMovieRepository(
      movies: catalog,
      failure: const CacheFailure(),
    );
    await pumpHome(tester, repo);

    expect(find.text('Impossible de charger les données.'), findsOneWidget);
    expect(find.text('Voir mes favoris'), findsOneWidget);

    repo.failure = null;
    await tester.tap(find.text('Réessayer'));
    await tester.pumpAndSettle();

    expect(find.text('Impossible de charger les données.'), findsNothing);
    expect(find.text('N°1 DES TENDANCES'), findsOneWidget);
  });
}
