// Génère les captures d'écran du README (docs/screenshots/*.png) à partir de
// l'application complète, avec le backend en mémoire des tests d'intégration.
//
//   flutter test tool/screenshots --update-goldens
//
// Volontairement hors de test/ : le rendu des polices varie selon le
// système, ces images ne servent pas de référence de non-régression.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_production_ready/features/favorites/domain/entities/favorite.dart';
import 'package:flutter_app_production_ready/features/movies/domain/entities/genre.dart';
import 'package:flutter_app_production_ready/features/movies/domain/entities/movie.dart';
import 'package:flutter_app_production_ready/features/movies/domain/entities/movie_category.dart';
import 'package:flutter_app_production_ready/features/movies/domain/entities/movie_details.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../integration_test/support/fake_backend.dart';
import '../../test/helpers/fake_favorites_repository.dart';
import '../../test/helpers/fake_movie_repository.dart';

const _titles = [
  ('Le Dernier Projectionniste', 18),
  ('Marée Basse', 53),
  ('Les Heures Claires', 18),
  ('Orbite Lente', 878),
  ('Nuit Blanche à Abidjan', 53),
  ('Le Phare des Oubliés', 18),
  ('Sous la Pluie de Mars', 10749),
  ('La Dernière Bobine', 35),
  ('Fréquence Nord', 878),
  ('Les Enfants du Quai', 18),
  ('Poussière d’Étoiles', 878),
  ('Un Été à Grand-Bassam', 10749),
];

Movie _movie(int index, {int offset = 0}) {
  final (title, genre) = _titles[(index + offset) % _titles.length];
  return Movie(
    id: offset * 100 + index + 1,
    title: title,
    originalTitle: title,
    releaseDate: DateTime(2019 + (index * 3 + offset) % 7, 3, 12),
    voteAverage: 6.4 + ((index * 7 + offset * 3) % 25) / 10,
    voteCount: 900,
    popularity: 60.0 + index * 4.3,
    genreIds: [genre],
  );
}

FakeMovieRepository _catalog() {
  final byCategory = {
    for (final category in MovieCategory.values)
      category: [
        for (var i = 0; i < 12; i++) _movie(i, offset: category.index * 4),
      ],
  };
  final repo = FakeMovieRepository(
    movies: byCategory,
    genres: const [
      Genre(id: 18, name: 'Drame'),
      Genre(id: 53, name: 'Thriller'),
      Genre(id: 35, name: 'Comédie'),
      Genre(id: 878, name: 'Science-Fiction'),
      Genre(id: 10749, name: 'Romance'),
    ],
  );
  final featured = byCategory[MovieCategory.trending]!.first;
  repo.details[featured.id] = MovieDetails(
    movie: Movie(
      id: featured.id,
      title: featured.title,
      originalTitle: 'Sleepless in Abidjan',
      overview:
          'Une nuit de coupure générale à Abidjan : un chauffeur de taxi et '
          'une étudiante traversent la ville endormie pour livrer la bobine '
          'd’un film avant l’aube.',
      releaseDate: featured.releaseDate,
      voteAverage: 8.2,
      voteCount: 900,
      popularity: 91.4,
      genreIds: featured.genreIds,
    ),
    runtime: 118,
    genres: const ['Comédie dramatique', 'Drame'],
    cast: const [
      CastMember(id: 7, name: 'Camille Serre', character: 'Lucie'),
      CastMember(id: 8, name: 'Yves Bamba', character: 'Henri'),
      CastMember(id: 9, name: 'Awa Traoré', character: 'Mariam'),
      CastMember(id: 10, name: 'Jean Kouassi', character: 'Le maire'),
    ],
    similar: byCategory[MovieCategory.popular]!.take(6).toList(),
  );
  repo.searchResults['la'] = [
    for (final i in [2, 7, 9, 10, 11, 5]) _movie(i),
  ];
  return repo;
}

FakeFavoritesRepository _favorites() => FakeFavoritesRepository([
  for (final (i, index) in [3, 6, 1, 8].indexed)
    Favorite.fromMovie(
      _movie(index),
      addedAt: DateTime(2026, 9, 20).add(Duration(days: i)),
    ),
]);

void main() {
  setUpAll(() async {
    // Police des icônes Material (absente par défaut en test).
    final icons = FontLoader('MaterialIcons')
      ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await icons.load();
  });

  Future<FakeBackend> launch(
    WidgetTester tester, {
    bool signedIn = true,
    Locale device = const Locale('fr'),
  }) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.reset);
    final backend = FakeBackend(
      signedIn: signedIn,
      movies: _catalog(),
      favorites: _favorites(),
    );
    await backend.launch(tester, device: device);
    await tester.pumpAndSettle();
    return backend;
  }

  Future<void> capture(WidgetTester tester, String name) async {
    // Les polices se chargent par de vraies E/S : on attend leur fin hors du
    // temps simulé, puis on redessine avec les bons glyphes.
    await tester.runAsync(GoogleFonts.pendingFonts);
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../../docs/screenshots/$name.png'),
    );
  }

  Finder tab(String label) => find.descendant(
    of: find.byType(NavigationBar),
    matching: find.text(label),
  );

  testWidgets('connexion', (tester) async {
    await launch(tester, signedIn: false);
    await capture(tester, '01_connexion');
  });

  testWidgets('accueil', (tester) async {
    await launch(tester);
    await capture(tester, '02_accueil');
  });

  testWidgets('fiche film', (tester) async {
    await launch(tester);
    await tester.tap(find.text('N°1 DES TENDANCES'));
    await tester.pumpUntilFound(find.text('1H58'));
    await capture(tester, '03_fiche_film');
  });

  testWidgets('recherche', (tester) async {
    await launch(tester);
    await tester.tap(tab('Recherche'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'La');
    await tester.pumpUntilFound(find.text('6 résultats'));
    FocusManager.instance.primaryFocus?.unfocus();
    await capture(tester, '04_recherche');
  });

  testWidgets('favoris', (tester) async {
    await launch(tester);
    await tester.tap(tab('Favoris'));
    await capture(tester, '05_favoris');
  });

  testWidgets('profil', (tester) async {
    await launch(tester);
    await tester.tap(tab('Profil'));
    await capture(tester, '06_profil');
  });

  testWidgets('accueil en anglais', (tester) async {
    await launch(tester, device: const Locale('en'));
    await capture(tester, '07_home_en');
  });
}
