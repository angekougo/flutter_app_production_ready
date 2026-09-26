import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../integration_test/support/fake_backend.dart';
import '../../integration_test/support/journeys.dart';

/// Les parcours des tests d'intégration (`integration_test/`), rejoués en
/// temps simulé : ils valident la logique en quelques secondes, sans
/// appareil, à chaque `flutter test`.
void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('parcours favori', favoriteJourney);
  testWidgets(
    'parcours recherche, langue et déconnexion',
    searchLanguageLogoutJourney,
  );
  testWidgets('scénario de défilement', (tester) async {
    await FakeBackend(signedIn: true).launch(tester);
    await tester.pumpUntilFound(find.text('N°1 DES TENDANCES'));
    await scrollCatalog(tester);
  });
}
