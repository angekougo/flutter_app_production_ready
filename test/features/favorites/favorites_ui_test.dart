import 'package:flutter/material.dart';
import 'package:flutter_app_production_ready/core/error/failures.dart';
import 'package:flutter_app_production_ready/core/l10n/locale_providers.dart';
import 'package:flutter_app_production_ready/core/result/result.dart';
import 'package:flutter_app_production_ready/features/auth/domain/entities/app_user.dart';
import 'package:flutter_app_production_ready/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter_app_production_ready/features/favorites/domain/entities/favorite.dart';
import 'package:flutter_app_production_ready/features/favorites/presentation/pages/favorites_page.dart';
import 'package:flutter_app_production_ready/features/favorites/presentation/providers/favorites_providers.dart';
import 'package:flutter_app_production_ready/features/movies/domain/entities/movie.dart';
import 'package:flutter_app_production_ready/features/movies/domain/entities/movie_details.dart';
import 'package:flutter_app_production_ready/features/movies/presentation/pages/movie_details_page.dart';
import 'package:flutter_app_production_ready/features/movies/presentation/providers/movie_providers.dart';
import 'package:flutter_app_production_ready/features/profile/domain/entities/profile_entities.dart';
import 'package:flutter_app_production_ready/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter_app_production_ready/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter_app_production_ready/features/profile/presentation/providers/profile_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/fake_favorites_repository.dart';
import '../../helpers/fake_movie_repository.dart';
import '../../helpers/finders.dart';
import '../../helpers/test_app.dart';

const awa = AppUser(
  id: 'awa',
  email: 'awa.konan@exemple.com',
  fullName: 'Awa Konan',
);

Favorite fav(int id, String title, {int daysAgo = 0}) => Favorite(
  movieId: id,
  title: title,
  releaseDate: DateTime(2024),
  voteAverage: 8.2,
  addedAt: DateTime(2026, 9, 26).subtract(Duration(days: daysAgo)),
);

class FakeProfileRepository implements ProfileRepository {
  FakeProfileRepository(
    this.profile, {
    this.expiresIn = const Duration(minutes: 52),
  });

  final Result<UserProfile> profile;
  final Duration expiresIn;

  @override
  Future<Result<UserProfile>> getProfile() async => profile;

  @override
  SessionInfo getSessionInfo() =>
      SessionInfo(hasSession: true, expiresAt: DateTime.now().add(expiresIn));

  @override
  Future<Result<OfflineStats>> getOfflineStats() async => Success(
    OfflineStats(
      cachedMovies: 128,
      favorites: 2,
      // 2 min 30 : loin des bornes, « IL Y A 2 MIN » est stable.
      lastUpdate: DateTime.now().subtract(
        const Duration(minutes: 2, seconds: 30),
      ),
    ),
  );
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  Future<void> pump(
    WidgetTester tester,
    Widget page, {
    required FakeFavoritesRepository favorites,
    FakeMovieRepository? movies,
    ProfileRepository? profile,
  }) async {
    tester.view.physicalSize = const Size(1170, 4200);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      ProviderScope(
        retry: (_, _) => null,
        overrides: [
          currentUserProvider.overrideWithValue(awa),
          sharedPreferencesProvider.overrideWithValue(prefs),
          authStateProvider.overrideWithValue(const AsyncData(awa)),
          favoritesRepositoryProvider.overrideWithValue(favorites),
          if (movies != null) movieRepositoryProvider.overrideWithValue(movies),
          if (profile != null)
            profileRepositoryProvider.overrideWithValue(profile),
        ],
        child: testApp(page),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('Mes favoris', () {
    testWidgets('liste du plus récent au plus ancien, compteur hors ligne', (
      tester,
    ) async {
      await pump(
        tester,
        const FavoritesPage(),
        favorites: FakeFavoritesRepository([
          fav(1, 'Marée Basse', daysAgo: 3),
          fav(2, 'Saison Sèche'),
        ]),
      );

      expect(find.text('2 films · disponibles hors connexion'), findsOneWidget);
      final titles = tester
          .widgetList<Text>(find.byType(Text))
          .map((t) => t.data)
          .where((t) => t == 'Marée Basse' || t == 'Saison Sèche')
          .toList();
      expect(titles.first, 'Saison Sèche');
      expect(findStarText('2024 · ★ 8,2'), findsNWidgets(2));
    });

    testWidgets('état vide', (tester) async {
      await pump(
        tester,
        const FavoritesPage(),
        favorites: FakeFavoritesRepository(),
      );

      expect(find.text('Aucun favori pour l’instant'), findsOneWidget);
      expect(find.text('Découvrir des films'), findsOneWidget);
    });

    testWidgets('retirer puis « Annuler » restaure le favori', (tester) async {
      final repo = FakeFavoritesRepository([fav(1, 'Marée Basse')]);
      await pump(tester, const FavoritesPage(), favorites: repo);

      await tester.tap(find.byTooltip('Retirer des favoris'));
      await tester.pumpAndSettle();
      expect(repo.items, isEmpty);
      expect(find.text('Aucun favori pour l’instant'), findsOneWidget);
      expect(find.text('« Marée Basse » retiré des favoris.'), findsOneWidget);

      await tester.tap(find.text('Annuler'));
      await tester.pumpAndSettle();
      expect(repo.items.single.title, 'Marée Basse');
      expect(find.text('1 film · disponible hors connexion'), findsOneWidget);
    });
  });

  testWidgets('fiche film : le cœur ajoute puis retire le favori', (
    tester,
  ) async {
    final favorites = FakeFavoritesRepository();
    await pump(
      tester,
      const MovieDetailsPage(movieId: 42),
      favorites: favorites,
      movies: FakeMovieRepository()
        ..details[42] = const MovieDetails(
          movie: Movie(id: 42, title: 'Le Dernier Projectionniste'),
          genres: ['Drame'],
        ),
    );

    await tester.tap(find.text('Ajouter aux favoris'));
    await tester.pumpAndSettle();

    expect(favorites.items.single.genres, ['Drame']);
    expect(find.text('Retirer des favoris'), findsOneWidget);
    expect(
      find.text('Ajouté aux favoris · disponible hors connexion.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Retirer des favoris'));
    await tester.pumpAndSettle();
    expect(favorites.items, isEmpty);
    expect(find.text('Ajouter aux favoris'), findsOneWidget);
  });

  group('Profil', () {
    testWidgets('compte, session active et données hors connexion', (
      tester,
    ) async {
      await pump(
        tester,
        const ProfilePage(),
        favorites: FakeFavoritesRepository(),
        profile: FakeProfileRepository(
          Success(
            UserProfile(
              id: 'awa',
              email: 'awa.konan@exemple.com',
              createdAt: DateTime(2026, 3, 2),
              provider: 'email',
            ),
          ),
        ),
      );

      expect(find.text('AK'), findsOneWidget);
      expect(find.text('Awa Konan'), findsOneWidget);
      expect(find.text('MARS 2026'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
      expect(find.text('Email · Supabase'), findsOneWidget);
      expect(find.textContaining('EXPIRE DANS 5'), findsOneWidget);
      expect(find.text('128'), findsOneWidget);
      expect(find.text('IL Y A 2 MIN'), findsOneWidget);
      expect(find.text('Votre session a expiré.'), findsNothing);
    });

    testWidgets('session expirée : carte « Se reconnecter »', (tester) async {
      await pump(
        tester,
        const ProfilePage(),
        favorites: FakeFavoritesRepository(),
        profile: FakeProfileRepository(
          const Error(UnauthorizedFailure()),
          expiresIn: const Duration(minutes: -5),
        ),
      );

      expect(find.text('Votre session a expiré.'), findsOneWidget);
      expect(find.text('Se reconnecter'), findsOneWidget);
      expect(find.text('Expirée'), findsOneWidget);
      expect(find.text('EXPIRÉ'), findsOneWidget);
    });
  });
}
