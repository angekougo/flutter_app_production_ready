import 'package:flutter/material.dart';
import 'package:flutter_app_production_ready/features/movies/domain/entities/movie.dart';
import 'package:flutter_app_production_ready/features/movies/domain/entities/movie_category.dart';
import 'package:flutter_app_production_ready/features/movies/presentation/pages/movie_list_page.dart';
import 'package:flutter_app_production_ready/features/movies/presentation/providers/movie_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../helpers/fake_movie_repository.dart';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  final movies = [
    for (var i = 1; i <= 12; i++)
      Movie(
        id: i,
        title: 'Un titre de film particulièrement long n°$i',
        releaseDate: DateTime(2026, 7, 29),
        voteAverage: 7.863,
        voteCount: 100,
      ),
  ];

  // Régression : « A RenderFlex overflowed by 2.3 pixels on the bottom ».
  // Tout débordement est remonté comme une erreur et fait échouer le test.
  for (final (width, textScale) in [
    (320.0, 1.0),
    (360.0, 1.0),
    (393.0, 1.15),
    (411.0, 1.3),
    (430.0, 2.0),
  ]) {
    testWidgets(
      'grille sans débordement (${width.toInt()} dp, texte ×$textScale)',
      (tester) async {
        tester.view.physicalSize = Size(width * 3, 2400);
        tester.view.devicePixelRatio = 3;
        tester.platformDispatcher.textScaleFactorTestValue = textScale;
        addTearDown(tester.view.reset);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

        await tester.pumpWidget(
          ProviderScope(
            retry: (_, _) => null,
            overrides: [
              movieRepositoryProvider.overrideWithValue(
                FakeMovieRepository(movies: {MovieCategory.popular: movies}),
              ),
            ],
            child: const MaterialApp(
              home: MovieListPage(category: MovieCategory.popular),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('2026 · ★ 7,9'), findsWidgets);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
