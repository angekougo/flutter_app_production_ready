import 'package:flutter/material.dart';
import 'package:flutter_app_production_ready/core/network/network_info.dart';
import 'package:flutter_app_production_ready/core/providers/core_providers.dart';
import 'package:flutter_app_production_ready/features/auth/domain/entities/app_user.dart';
import 'package:flutter_app_production_ready/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter_app_production_ready/features/favorites/presentation/providers/favorites_providers.dart';
import 'package:flutter_app_production_ready/features/home/presentation/pages/home_page.dart';
import 'package:flutter_app_production_ready/features/movies/domain/entities/movie.dart';
import 'package:flutter_app_production_ready/features/movies/domain/entities/movie_category.dart';
import 'package:flutter_app_production_ready/features/movies/domain/entities/movie_details.dart';
import 'package:flutter_app_production_ready/features/movies/presentation/pages/movie_details_page.dart';
import 'package:flutter_app_production_ready/features/movies/presentation/providers/movie_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helpers/fake_favorites_repository.dart';
import '../helpers/fake_movie_repository.dart';
import '../helpers/test_app.dart';

class _OnlineNetworkInfo implements NetworkInfo {
  @override
  Future<bool> get isConnected async => true;
  @override
  Stream<bool> get onStatusChange => const Stream.empty();
}

Movie _movie(int id, String title) => Movie(
  id: id,
  title: title,
  releaseDate: DateTime(2024, 3, 12),
  voteAverage: 8.2,
  voteCount: 10,
  genreIds: const [18],
);

/// Ce qu'entend un utilisateur de TalkBack / VoiceOver : chaque élément
/// interactif est un bouton au libellé explicite, sans doublon ni symbole.
void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  Future<SemanticsHandle> pump(
    WidgetTester tester,
    Widget page, {
    Locale locale = testLocale,
    bool fromCache = false,
  }) async {
    final handle = tester.ensureSemantics();
    tester.view.physicalSize = const Size(1170, 4000);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    final movies =
        FakeMovieRepository(
            fromCache: fromCache,
            cachedAt: fromCache ? DateTime.now() : null,
            movies: {
              MovieCategory.trending: [
                _movie(1, 'Le Dernier Projectionniste'),
                _movie(2, 'Marée Basse'),
              ],
              MovieCategory.popular: [_movie(3, 'Les Heures Claires')],
              MovieCategory.nowPlaying: [_movie(4, 'Orbite Lente')],
            },
          )
          ..details[1] = MovieDetails(
            movie: _movie(1, 'Le Dernier Projectionniste'),
            runtime: 118,
            cast: const [
              CastMember(id: 7, name: 'Camille Serre', character: 'Lucie'),
            ],
          );

    await tester.pumpWidget(
      ProviderScope(
        retry: (_, _) => null,
        overrides: [
          networkInfoProvider.overrideWithValue(_OnlineNetworkInfo()),
          movieRepositoryProvider.overrideWithValue(movies),
          favoritesRepositoryProvider.overrideWithValue(
            FakeFavoritesRepository(),
          ),
          currentUserProvider.overrideWithValue(
            const AppUser(id: 'u', email: 'awa@x.com', fullName: 'Awa Konan'),
          ),
        ],
        child: testApp(page, locale: locale),
      ),
    );
    await tester.pumpAndSettle();
    return handle;
  }

  testWidgets('accueil : carte à la une et affiches lues comme des boutons', (
    tester,
  ) async {
    final handle = await pump(tester, const HomePage());

    expect(
      tester.getSemantics(
        find.bySemanticsLabel(
          'N°1 des tendances : Le Dernier Projectionniste, 2024, Drame, '
          'note 8,2 sur 10',
        ),
      ),
      isSemantics(isButton: true, hasTapAction: true),
    );
    expect(
      tester.getSemantics(
        find.bySemanticsLabel('Les Heures Claires, note 8,2 sur 10'),
      ),
      isSemantics(isButton: true, hasTapAction: true),
    );
    // Le symbole « ★ » du badge n'est jamais lu tel quel.
    expect(find.bySemanticsLabel(RegExp('★')), findsNothing);
    // Titres de sections navigables comme en-têtes.
    expect(
      tester.getSemantics(find.bySemanticsLabel('Populaires')),
      isSemantics(isHeader: true),
    );
    handle.dispose();
  });

  testWidgets('libellés traduits en anglais', (tester) async {
    final handle = await pump(
      tester,
      const HomePage(),
      locale: const Locale('en'),
    );

    expect(
      find.bySemanticsLabel('Les Heures Claires, rated 8.2 out of 10'),
      findsOneWidget,
    );
    handle.dispose();
  });

  testWidgets('fiche film : état du favori, note et casting', (tester) async {
    final handle = await pump(tester, const MovieDetailsPage(movieId: 1));

    expect(
      tester.getSemantics(find.byTooltip('Ajouter aux favoris')),
      isSemantics(hasToggledState: true, isToggled: false),
    );
    expect(
      find.bySemanticsLabel(RegExp(r'NOTE\s+note 8,2 sur 10')),
      findsOneWidget,
    );
    expect(
      tester.getSemantics(
        find.bySemanticsLabel('Camille Serre, dans le rôle de Lucie'),
      ),
      isSemantics(isButton: true, hasTapAction: true),
    );
    handle.dispose();
  });

  testWidgets('bannière hors ligne annoncée automatiquement', (tester) async {
    final handle = await pump(tester, const HomePage(), fromCache: true);

    expect(
      tester.getSemantics(find.bySemanticsLabel(RegExp('^Hors connexion'))),
      isSemantics(isLiveRegion: true),
    );
    handle.dispose();
  });
}
