import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_backend.dart';

/// Parcours utilisateur de bout en bout, partagés par les tests
/// d'intégration (appareil réel) et leur exécution rapide en CI.

Finder _tab(String label) =>
    find.descendant(of: find.byType(NavigationBar), matching: find.text(label));

/// Fait défiler l'écran jusqu'à [finder] (les listes ne construisent que
/// les éléments proches de l'écran), puis le touche.
Future<void> _tapVisible(WidgetTester tester, Finder finder) async {
  await _scrollTo(tester, finder);
  await tester.ensureVisible(finder);
  await tester.pump();
  await tester.tap(finder);
  await tester.pump();
}

Future<void> _scrollTo(WidgetTester tester, Finder finder) async {
  if (finder.evaluate().isNotEmpty) return;
  await tester.scrollUntilVisible(
    finder,
    300,
    scrollable: find.byType(Scrollable).first,
  );
}

/// Connexion → accueil → fiche du n°1 → favori → onglet Favoris →
/// retrait puis « Annuler ».
Future<void> favoriteJourney(WidgetTester tester) async {
  final backend = FakeBackend();
  await backend.launch(tester);

  // 1. Mauvais mot de passe : message d'erreur, pas de navigation.
  expect(find.text('Bon retour.'), findsOneWidget);
  final fields = find.byType(TextFormField);
  await tester.enterText(fields.at(0), FakeAuthRepository.email);
  await tester.enterText(fields.at(1), 'mauvais');
  await _tapVisible(tester, find.text('Se connecter'));
  await tester.pumpUntilFound(find.text('Email ou mot de passe incorrect.'));

  // 2. Bon mot de passe : le routeur ouvre l'accueil.
  await tester.enterText(fields.at(1), FakeAuthRepository.password);
  await _tapVisible(tester, find.text('Se connecter'));
  await tester.pumpUntilFound(find.byType(NavigationBar));
  await tester.pumpUntilFound(find.text('N°1 DES TENDANCES'));
  expect(find.textContaining(', AWA'), findsOneWidget);

  // 3. Fiche du film à la une, ajout aux favoris.
  await _tapVisible(tester, find.text('N°1 DES TENDANCES'));
  await tester.pumpUntilFound(find.text('1H58'));
  await _tapVisible(tester, find.text('Ajouter aux favoris'));
  await tester.pumpUntilFound(
    find.text('Ajouté aux favoris · disponible hors connexion.'),
  );
  expect(backend.favorites.items, hasLength(1));
  expect(find.text('Retirer des favoris'), findsOneWidget);

  // 4. Retour, onglet Favoris : le film y est.
  await tester.tap(find.byTooltip('Retour'));
  await tester.pumpUntilFound(find.byType(NavigationBar));
  await tester.tap(_tab('Favoris'));
  await tester.pumpUntilFound(find.text('Mes favoris'));
  await tester.pumpUntilFound(find.text('1 film · disponible hors connexion'));

  // 5. Retrait puis « Annuler » : le favori est restauré.
  await tester.tap(find.byTooltip('Retirer des favoris'));
  await tester.pumpUntilFound(find.text('Aucun favori pour l’instant'));
  await tester.pumpUntilFound(find.text('Annuler'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Annuler'));
  await tester.pumpUntilFound(find.text('1 film · disponible hors connexion'));
  expect(backend.favorites.items, hasLength(1));
}

/// Session restaurée → recherche → fiche → Profil : passage en anglais →
/// déconnexion.
Future<void> searchLanguageLogoutJourney(WidgetTester tester) async {
  final backend = FakeBackend(signedIn: true);
  await backend.launch(tester);
  expect(find.byType(NavigationBar), findsOneWidget);

  // 1. Recherche (anti-rebond) puis ouverture d'un résultat.
  await tester.tap(_tab('Recherche'));
  await tester.pumpUntilFound(find.text('TITRE DU FILM'));
  await tester.enterText(find.byType(TextField), 'Marée');
  await tester.pumpUntilFound(find.text('2 résultats'));
  expect(backend.movies.searchCalls, ['Marée']);
  await tester.tap(find.text('Marée Basse'));
  await tester.pumpUntilFound(
    find.text('Synopsis non disponible pour ce film.'),
  );
  await tester.tap(find.byTooltip('Retour'));
  await tester.pumpUntilFound(find.text('2 résultats'));

  // 2. Profil : l'application passe en anglais, contenus compris.
  await tester.tap(_tab('Profil'));
  await tester.pumpUntilFound(find.text('COMPTE'));
  await _tapVisible(tester, find.text('Langue'));
  await tester.pumpUntilFound(find.text('Langue de l’application'));
  await tester.pumpAndSettle(); // fin de l'ouverture de la feuille
  await tester.tap(find.text('English'));
  await tester.pumpUntilFound(_tab('Home'));
  expect(find.text('Language'), findsOneWidget);
  expect(_tab('Accueil'), findsNothing);

  // 3. Déconnexion : retour à l'écran de connexion (en anglais).
  await _tapVisible(tester, find.text('Sign out'));
  await tester.pumpUntilFound(find.text('Welcome back.'));
  expect(backend.auth.currentUser, isNull);
}

/// Défilement intensif : accueil (vertical + carrousel), puis grille
/// « Tout voir » de 60 affiches. Sert à mesurer le temps de chaque image.
Future<void> scrollCatalog(WidgetTester tester) async {
  final home = find.byType(CustomScrollView).first;
  for (var i = 0; i < 2; i++) {
    await tester.fling(home, const Offset(0, -600), 2000);
    await tester.pumpAndSettle();
    await tester.fling(home, const Offset(0, 600), 2000);
    await tester.pumpAndSettle();
  }

  final carousel = find.byType(ListView).at(1);
  await tester.fling(carousel, const Offset(-800, 0), 3000);
  await tester.pumpAndSettle();

  await tester.tap(find.text('Tout voir').first);
  // La grille « Tout voir » est le seul écran avec une AppBar.
  await tester.pumpUntilFound(find.byType(AppBar));
  await tester.pumpAndSettle();
  final grid = find.byType(CustomScrollView).last;
  for (var i = 0; i < 3; i++) {
    await tester.fling(grid, const Offset(0, -900), 3000);
    await tester.pumpAndSettle();
  }
  await tester.fling(grid, const Offset(0, 2700), 4000);
  await tester.pumpAndSettle();
}
