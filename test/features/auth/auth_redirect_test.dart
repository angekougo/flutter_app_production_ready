import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_app_production_ready/app/app.dart';
import 'package:flutter_app_production_ready/core/l10n/locale_providers.dart';
import 'package:flutter_app_production_ready/core/network/network_info.dart';
import 'package:flutter_app_production_ready/core/providers/core_providers.dart';
import 'package:flutter_app_production_ready/features/auth/domain/entities/app_user.dart';
import 'package:flutter_app_production_ready/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_app_production_ready/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter_app_production_ready/features/movies/presentation/providers/movie_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/fake_movie_repository.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

class _OnlineNetworkInfo implements NetworkInfo {
  @override
  Future<bool> get isConnected async => true;
  @override
  Stream<bool> get onStatusChange => const Stream.empty();
}

/// Régression : le routeur doit réagir aux changements de session sans
/// qu'aucune navigation manuelle ne soit nécessaire.
void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('connexion → Accueil, déconnexion → Login', (tester) async {
    final session = StreamController<AppUser?>.broadcast();
    addTearDown(session.close);
    AppUser? current;
    final repository = _MockAuthRepository();
    when(() => repository.currentUser).thenAnswer((_) => current);
    when(repository.watchAuthState).thenAnswer((_) => session.stream);
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        retry: (_, _) => null,
        overrides: [
          authRepositoryProvider.overrideWithValue(repository),
          networkInfoProvider.overrideWithValue(_OnlineNetworkInfo()),
          movieRepositoryProvider.overrideWithValue(FakeMovieRepository()),
          sharedPreferencesProvider.overrideWithValue(prefs),
          deviceLocalesProvider.overrideWithValue(const [Locale('fr')]),
        ],
        child: const CinethequeApp(),
      ),
    );
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.text('Bon retour.'), findsOneWidget);

    // Connexion : Supabase met à jour la session puis émet l'événement.
    current = const AppUser(id: '1', email: 'awa@exemple.com');
    session.add(current);
    await tester.pumpAndSettle();
    expect(find.text('Bon retour.'), findsNothing);
    expect(find.text('Accueil'), findsOneWidget);

    // Déconnexion.
    current = null;
    session.add(null);
    await tester.pumpAndSettle();
    expect(find.text('Bon retour.'), findsOneWidget);
  });
}
