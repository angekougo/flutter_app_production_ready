import 'package:flutter/material.dart';
import 'package:flutter_app_production_ready/core/network/network_info.dart';
import 'package:flutter_app_production_ready/core/providers/core_providers.dart';
import 'package:flutter_app_production_ready/features/auth/domain/entities/app_user.dart';
import 'package:flutter_app_production_ready/features/auth/presentation/pages/register_page.dart';
import 'package:flutter_app_production_ready/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter_app_production_ready/features/auth/presentation/widgets/password_strength_indicator.dart';
import 'package:flutter_app_production_ready/features/home/presentation/pages/home_page.dart';
import 'package:flutter_app_production_ready/features/movies/domain/entities/movie.dart';
import 'package:flutter_app_production_ready/features/movies/domain/entities/movie_category.dart';
import 'package:flutter_app_production_ready/features/movies/presentation/pages/search_page.dart';
import 'package:flutter_app_production_ready/features/movies/presentation/providers/movie_providers.dart';
import 'package:flutter_app_production_ready/shared/widgets/skeleton.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helpers/fake_movie_repository.dart';
import '../helpers/rebuild_counter.dart';
import '../helpers/test_app.dart';

/// Saisir du texte ne doit reconstruire que les widgets qui en dépendent,
/// jamais l'écran entier (60 fps pendant la frappe, même sur petit
/// appareil).
void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('inscription : la frappe ne reconstruit pas l’écran', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(child: testApp(const RegisterPage())),
    );
    final passwordField = find.byType(TextFormField).at(2);
    final confirmationField = find.byType(TextFormField).at(3);

    final counter = RebuildCounter();
    await counter.record(() async {
      await tester.enterText(passwordField, 'CinemaClub7!');
      await tester.enterText(confirmationField, 'CinemaClub7!');
      await tester.pump();
    });

    // La jauge suit la saisie…
    expect(counter.of(PasswordStrengthIndicator), greaterThan(0));
    expect(find.text('Les mots de passe correspondent.'), findsOneWidget);
    // … sans reconstruire la page.
    expect(counter.of(RegisterPage), 0);
  });

  testWidgets('recherche : la frappe ne reconstruit pas l’écran', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          movieRepositoryProvider.overrideWithValue(FakeMovieRepository()),
        ],
        child: testApp(const SearchPage()),
      ),
    );
    await tester.pumpAndSettle();

    final counter = RebuildCounter();
    await counter.record(() async {
      await tester.enterText(find.byType(TextField), 'a');
      await tester.pump();
    });

    // Le bouton « Effacer » et l'aide à la saisie apparaissent…
    expect(find.byTooltip('Effacer la recherche'), findsOneWidget);
    expect(find.text('Saisissez au moins 2 caractères.'), findsOneWidget);
    // … sans reconstruire la page.
    expect(counter.of(SearchPage), 0);
  });

  homeAndAnimationTests();
}

class _UserNotifier extends Notifier<AppUser?> {
  @override
  AppUser? build() =>
      const AppUser(id: 'u', email: 'awa@x.com', fullName: 'Awa Konan');

  void set(AppUser user) => state = user;
}

final _userProvider = NotifierProvider<_UserNotifier, AppUser?>(
  _UserNotifier.new,
);

class _OnlineNetworkInfo implements NetworkInfo {
  @override
  Future<bool> get isConnected async => true;
  @override
  Stream<bool> get onStatusChange => const Stream.empty();
}

void homeAndAnimationTests() {
  testWidgets('accueil : un nouvel objet utilisateur sans changement de '
      'prénom (rafraîchissement du JWT) ne reconstruit pas l’écran', (
    tester,
  ) async {
    final container = ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        currentUserProvider.overrideWith((ref) => ref.watch(_userProvider)),
        networkInfoProvider.overrideWithValue(_OnlineNetworkInfo()),
        movieRepositoryProvider.overrideWithValue(
          FakeMovieRepository(
            movies: {
              MovieCategory.popular: const [Movie(id: 1, title: 'Marée Basse')],
            },
          ),
        ),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: testApp(const HomePage()),
      ),
    );
    await tester.pumpAndSettle();

    final counter = RebuildCounter();
    await counter.record(() async {
      container
          .read(_userProvider.notifier)
          .set(
            AppUser(
              id: 'u',
              email: 'awa@x.com',
              fullName: 'Awa Konan',
              createdAt: DateTime(2026),
            ),
          );
      await tester.pump();
    });

    expect(counter.of(HomePage), 0);
  });

  testWidgets('squelette : la pulsation ne reconstruit aucun widget', (
    tester,
  ) async {
    await tester.pumpWidget(
      testApp(const Scaffold(body: SkeletonBox(width: 100, height: 100))),
    );

    final counter = RebuildCounter();
    await counter.record(() => tester.pump(const Duration(milliseconds: 450)));
    // L'animation avance…
    final fade = tester.widget<FadeTransition>(
      find.descendant(
        of: find.byType(SkeletonBox),
        matching: find.byType(FadeTransition),
      ),
    );
    expect(fade.opacity.value, greaterThan(0));
    // … sans aucun build.
    expect(counter.of(SkeletonBox), 0);
  });
}
