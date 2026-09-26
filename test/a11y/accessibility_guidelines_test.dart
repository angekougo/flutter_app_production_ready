import 'package:flutter/material.dart';
import 'package:flutter_app_production_ready/core/network/network_info.dart';
import 'package:flutter_app_production_ready/core/providers/core_providers.dart';
import 'package:flutter_app_production_ready/features/auth/domain/entities/app_user.dart';
import 'package:flutter_app_production_ready/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_app_production_ready/features/auth/presentation/pages/register_page.dart';
import 'package:flutter_app_production_ready/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter_app_production_ready/features/favorites/domain/entities/favorite.dart';
import 'package:flutter_app_production_ready/features/favorites/presentation/pages/favorites_page.dart';
import 'package:flutter_app_production_ready/features/favorites/presentation/providers/favorites_providers.dart';
import 'package:flutter_app_production_ready/features/home/presentation/pages/home_page.dart';
import 'package:flutter_app_production_ready/features/movies/domain/entities/movie.dart';
import 'package:flutter_app_production_ready/features/movies/domain/entities/movie_category.dart';
import 'package:flutter_app_production_ready/features/movies/domain/entities/movie_details.dart';
import 'package:flutter_app_production_ready/features/movies/presentation/pages/movie_details_page.dart';
import 'package:flutter_app_production_ready/features/movies/presentation/pages/search_page.dart';
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

final _catalog = {
  for (final category in MovieCategory.values)
    category: [
      _movie(category.index * 10 + 1, 'Le Dernier Projectionniste'),
      _movie(category.index * 10 + 2, 'Marée Basse'),
    ],
};

final _details = MovieDetails(
  movie: _movie(1, 'Le Dernier Projectionniste'),
  runtime: 118,
  genres: const ['Drame'],
  cast: const [CastMember(id: 7, name: 'Camille Serre', character: 'Lucie')],
  similar: [_movie(2, 'Marée Basse')],
);

/// Règles d'accessibilité de Flutter appliquées aux écrans principaux :
/// cibles tactiles ≥ 48 dp (Android) / 44 pt (iOS), éléments interactifs
/// étiquetés pour les lecteurs d'écran. Le contraste est vérifié sur la
/// palette (`color_contrast_test.dart`) : `textContrastGuideline` échantillonne
/// les pixels et sous-estime le contraste des polices fines anticrénelées.
void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  final screens = <String, Widget>{
    'Connexion': const LoginPage(),
    'Inscription': const RegisterPage(),
    'Accueil': const HomePage(),
    'Recherche': const SearchPage(),
    'Fiche film': MovieDetailsPage(movieId: 1, preview: _details.movie),
    'Favoris': const FavoritesPage(),
  };

  for (final MapEntry(key: name, value: page) in screens.entries) {
    testWidgets('$name respecte les règles d’accessibilité', (tester) async {
      final handle = tester.ensureSemantics();
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ProviderScope(
          retry: (_, _) => null,
          overrides: [
            networkInfoProvider.overrideWithValue(_OnlineNetworkInfo()),
            movieRepositoryProvider.overrideWithValue(
              FakeMovieRepository(movies: _catalog)..details[1] = _details,
            ),
            favoritesRepositoryProvider.overrideWithValue(
              FakeFavoritesRepository([
                Favorite(
                  movieId: 1,
                  title: 'Le Dernier Projectionniste',
                  releaseDate: DateTime(2024),
                  voteAverage: 8.2,
                  addedAt: DateTime(2026, 9, 26),
                ),
              ]),
            ),
            currentUserProvider.overrideWithValue(
              const AppUser(id: 'u', email: 'awa@x.com', fullName: 'Awa Konan'),
            ),
          ],
          child: testApp(page),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      handle.dispose();
    });
  }
}
