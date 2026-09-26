import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_production_ready/app/app.dart';
import 'package:flutter_app_production_ready/core/error/failures.dart';
import 'package:flutter_app_production_ready/core/l10n/locale_providers.dart';
import 'package:flutter_app_production_ready/core/network/network_info.dart';
import 'package:flutter_app_production_ready/core/providers/core_providers.dart';
import 'package:flutter_app_production_ready/core/result/result.dart';
import 'package:flutter_app_production_ready/features/auth/domain/entities/app_user.dart';
import 'package:flutter_app_production_ready/features/auth/domain/entities/sign_up_result.dart';
import 'package:flutter_app_production_ready/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_app_production_ready/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter_app_production_ready/features/favorites/presentation/providers/favorites_providers.dart';
import 'package:flutter_app_production_ready/features/movies/domain/entities/genre.dart';
import 'package:flutter_app_production_ready/features/movies/domain/entities/movie.dart';
import 'package:flutter_app_production_ready/features/movies/domain/entities/movie_category.dart';
import 'package:flutter_app_production_ready/features/movies/domain/entities/movie_details.dart';
import 'package:flutter_app_production_ready/features/movies/presentation/providers/movie_providers.dart';
import 'package:flutter_app_production_ready/features/profile/domain/entities/profile_entities.dart';
import 'package:flutter_app_production_ready/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter_app_production_ready/features/profile/presentation/providers/profile_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../test/helpers/fake_favorites_repository.dart';
import '../../test/helpers/fake_movie_repository.dart';

/// Backend en mémoire : l'application complète (routeur, thème, traductions,
/// navigation) tourne sans réseau, sans Supabase ni TMDB. Les parcours sont
/// ainsi reproductibles en CI.
class FakeBackend {
  FakeBackend({bool signedIn = false})
    : auth = FakeAuthRepository(signedIn: signedIn),
      movies = _catalog(),
      favorites = FakeFavoritesRepository();

  final FakeAuthRepository auth;
  final FakeMovieRepository movies;
  final FakeFavoritesRepository favorites;

  /// Lance l'application et attend la fin de l'écran de démarrage.
  Future<void> launch(
    WidgetTester tester, {
    Locale device = const Locale('fr'),
  }) async {
    GoogleFonts.config.allowRuntimeFetching = false;
    // Le binding d'intégration laisse le vrai clavier du système actif :
    // `enterText` enverrait alors le texte à une connexion de saisie
    // périmée dès que le focus change. On active le clavier simulé.
    if (!tester.testTextInput.isRegistered) tester.testTextInput.register();
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        retry: (_, _) => null,
        overrides: [
          authRepositoryProvider.overrideWithValue(auth),
          movieRepositoryProvider.overrideWithValue(movies),
          favoritesRepositoryProvider.overrideWithValue(favorites),
          profileRepositoryProvider.overrideWithValue(
            _FakeProfileRepository(auth),
          ),
          networkInfoProvider.overrideWithValue(_OnlineNetworkInfo()),
          sharedPreferencesProvider.overrideWithValue(prefs),
          deviceLocalesProvider.overrideWithValue([device]),
        ],
        child: const CinethequeApp(),
      ),
    );
    // Le Splash reste affiché au moins 1,2 s avant de rediriger.
    await tester.pumpUntilFound(
      find.byWidgetPredicate((w) => w is NavigationBar || w is Form),
    );
  }

  static FakeMovieRepository _catalog() {
    Movie movie(int id, String title, int genre) => Movie(
      id: id,
      title: title,
      originalTitle: title,
      releaseDate: DateTime(2020 + id % 6, 3, 12),
      voteAverage: 6 + (id % 40) / 10,
      voteCount: 100 + id,
      popularity: 50.0 + id,
      genreIds: [genre],
    );

    // 60 films par catégorie : de quoi faire défiler les grilles.
    final byCategory = {
      for (final category in MovieCategory.values)
        category: [
          for (var i = 1; i <= 60; i++)
            movie(
              category.index * 100 + i,
              '${_titles[i % _titles.length]} $i',
              i.isEven ? 18 : 53,
            ),
        ],
    };
    final repo = FakeMovieRepository(
      movies: byCategory,
      genres: const [
        Genre(id: 18, name: 'Drame'),
        Genre(id: 53, name: 'Thriller'),
      ],
    );

    final featured = byCategory[MovieCategory.trending]!.first;
    repo.details[featured.id] = MovieDetails(
      movie: featured.copyWithOverview(
        'Dans un cinéma de quartier promis à la démolition, un projectionniste '
        'prépare une dernière séance.',
      ),
      runtime: 118,
      genres: const ['Drame'],
      cast: const [
        CastMember(id: 7, name: 'Camille Serre', character: 'Lucie'),
        CastMember(id: 8, name: 'Yves Bamba', character: 'Henri'),
      ],
      similar: byCategory[MovieCategory.popular]!.take(5).toList(),
    );
    repo.searchResults['marée'] = [
      movie(900, 'Marée Basse', 53),
      movie(901, 'Marée Haute', 18),
    ];
    repo.details[900] = MovieDetails(movie: movie(900, 'Marée Basse', 53));
    return repo;
  }

  static const _titles = [
    'Le Dernier Projectionniste',
    'Les Heures Claires',
    'Orbite Lente',
    'Nuit Blanche',
    'Le Phare',
    'Sous la Pluie',
  ];
}

extension on Movie {
  Movie copyWithOverview(String overview) => Movie(
    id: id,
    title: title,
    originalTitle: originalTitle,
    overview: overview,
    releaseDate: releaseDate,
    voteAverage: voteAverage,
    voteCount: voteCount,
    popularity: popularity,
    genreIds: genreIds,
  );
}

/// Authentification en mémoire : un seul compte valide.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({bool signedIn = false})
    : _current = signedIn ? awa : null;

  static const email = 'awa.konan@exemple.com';
  static const password = 'CinemaClub7!';
  static const awa = AppUser(id: 'awa', email: email, fullName: 'Awa Konan');

  AppUser? _current;
  final _changes = StreamController<AppUser?>.broadcast();

  @override
  AppUser? get currentUser => _current;

  @override
  Stream<AppUser?> watchAuthState() => _changes.stream;

  @override
  Future<Result<AppUser>> signIn({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (email.trim() != FakeAuthRepository.email ||
        password != FakeAuthRepository.password) {
      return const Error(AuthFailure());
    }
    _current = awa;
    _changes.add(awa);
    return const Success(awa);
  }

  @override
  Future<Result<SignUpResult>> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async => Success(
    SignUpResult(
      user: AppUser(id: 'new', email: email, fullName: fullName),
      emailConfirmationRequired: true,
    ),
  );

  @override
  Future<Result<void>> signOut() async {
    _current = null;
    _changes.add(null);
    return const Success(null);
  }
}

class _FakeProfileRepository implements ProfileRepository {
  _FakeProfileRepository(this._auth);

  final FakeAuthRepository _auth;

  @override
  Future<Result<UserProfile>> getProfile() async {
    final user = _auth.currentUser;
    if (user == null) return const Error(UnauthorizedFailure());
    return Success(
      UserProfile(
        id: user.id,
        email: user.email,
        fullName: user.fullName,
        createdAt: DateTime(2026, 3),
        provider: 'email',
      ),
    );
  }

  @override
  SessionInfo getSessionInfo() => SessionInfo(
    hasSession: _auth.currentUser != null,
    expiresAt: DateTime.now().add(const Duration(minutes: 52)),
  );

  @override
  Future<Result<OfflineStats>> getOfflineStats() async =>
      const Success(OfflineStats(cachedMovies: 180, favorites: 0));
}

class _OnlineNetworkInfo implements NetworkInfo {
  @override
  Future<bool> get isConnected async => true;
  @override
  Stream<bool> get onStatusChange => const Stream.empty();
}

extension PumpUntilX on WidgetTester {
  /// Avance jusqu'à ce que [finder] trouve un widget. Fonctionne en temps
  /// réel (appareil) comme en temps simulé (tests de widgets).
  Future<void> pumpUntilFound(
    Finder finder, {
    Duration timeout = const Duration(seconds: 15),
  }) async {
    final end = binding.clock.now().add(timeout);
    while (finder.evaluate().isEmpty) {
      if (binding.clock.now().isAfter(end)) {
        // Diagnostic : ce que l'écran affiche au moment du blocage.
        final onScreen = find
            .byType(Text)
            .evaluate()
            .map((e) {
              final text = e.widget as Text;
              return text.data ?? text.textSpan?.toPlainText();
            })
            .nonNulls
            .where((t) => t.trim().isNotEmpty)
            .take(40)
            .join(' | ');
        throw TestFailure(
          'Introuvable après $timeout : $finder\nÀ l’écran : $onScreen',
        );
      }
      await pump(const Duration(milliseconds: 100));
    }
  }
}
