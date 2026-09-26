import 'package:flutter/material.dart';
import 'package:flutter_app_production_ready/core/error/failures.dart';
import 'package:flutter_app_production_ready/features/movies/domain/entities/genre.dart';
import 'package:flutter_app_production_ready/features/movies/domain/entities/movie.dart';
import 'package:flutter_app_production_ready/features/movies/presentation/pages/search_page.dart';
import 'package:flutter_app_production_ready/features/movies/presentation/providers/movie_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../helpers/fake_movie_repository.dart';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  Future<void> pumpSearch(WidgetTester tester, FakeMovieRepository repo) async {
    await tester.pumpWidget(
      ProviderScope(
        retry: (_, _) => null,
        overrides: [movieRepositoryProvider.overrideWithValue(repo)],
        child: const MaterialApp(home: SearchPage()),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> type(WidgetTester tester, String text) async {
    await tester.enterText(find.byType(TextField), text);
    // Laisse passer l'anti-rebond.
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
  }

  testWidgets('affiche les résultats avec année, genre et note', (
    tester,
  ) async {
    final repo =
        FakeMovieRepository(genres: const [Genre(id: 53, name: 'Thriller')])
          ..searchResults['nuit'] = [
            Movie(
              id: 1,
              title: 'Nuit d’Encre',
              releaseDate: DateTime(2025),
              voteAverage: 6.8,
              voteCount: 10,
              genreIds: const [53],
            ),
          ];
    await pumpSearch(tester, repo);

    await type(tester, 'nuit');

    expect(find.text('1 résultat'), findsOneWidget);
    expect(find.text('PAGE 1 SUR 1'), findsOneWidget);
    expect(find.text('Nuit d’Encre'), findsOneWidget);
    expect(find.text('2025 · Thriller'), findsOneWidget);
    expect(find.text('★ 6,8'), findsOneWidget);
  });

  testWidgets('aucun résultat : message dédié', (tester) async {
    await pumpSearch(tester, FakeMovieRepository());

    await type(tester, 'zzqx');

    expect(find.text('Aucun résultat'), findsOneWidget);
    expect(find.textContaining('« zzqx »'), findsOneWidget);
  });

  testWidgets('hors ligne sans cache : message hors connexion', (tester) async {
    await pumpSearch(
      tester,
      FakeMovieRepository(failure: const CacheFailure()),
    );

    await type(tester, 'dune');

    expect(find.text('Recherche indisponible hors connexion'), findsOneWidget);
  });

  testWidgets('recherches récentes cliquables quand le champ est vide', (
    tester,
  ) async {
    final repo = FakeMovieRepository()
      ..recentSearches.addAll(['dune', 'la nuit'])
      ..searchResults['dune'] = [const Movie(id: 9, title: 'Dune')];
    await pumpSearch(tester, repo);

    expect(find.text('RECHERCHES RÉCENTES'), findsOneWidget);
    await tester.tap(find.text('dune'));
    await tester.pumpAndSettle();

    expect(repo.searchCalls, ['dune']);
    expect(find.text('Dune'), findsOneWidget);
  });
}
