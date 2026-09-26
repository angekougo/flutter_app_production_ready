import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'support/journeys.dart';

/// Parcours utilisateur sur l'application complète, exécutés sur un
/// appareil (ou le bureau Linux en CI) avec un backend en mémoire.
///
/// `flutter test integration_test/app_journeys_test.dart -d linux`
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'connexion, fiche film, favori puis retrait annulé',
    favoriteJourney,
  );

  testWidgets(
    'recherche, passage en anglais puis déconnexion',
    searchLanguageLogoutJourney,
  );
}
