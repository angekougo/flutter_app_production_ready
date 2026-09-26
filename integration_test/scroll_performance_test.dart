import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'support/fake_backend.dart';
import 'support/journeys.dart';

/// Mesure du temps de construction de chaque image pendant un défilement
/// intensif (accueil + grille de 60 affiches).
///
/// Mesures fiables uniquement en mode profile :
/// ```sh
/// flutter drive --profile --driver=test_driver/perf_driver.dart \
///   --target=integration_test/scroll_performance_test.dart -d linux
/// ```
///
/// Le résumé est écrit dans build/scrolling_summary.json.
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('défilement de l’accueil et des grilles à 60 fps', (
    tester,
  ) async {
    await FakeBackend(signedIn: true).launch(tester);
    await tester.pumpUntilFound(find.text('N°1 DES TENDANCES'));

    // Images produites comme dans l'application, au rythme de l'écran.
    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
    await binding.watchPerformance(
      () => scrollCatalog(tester),
      reportKey: 'scrolling',
    );

    final summary = binding.reportData!['scrolling'] as Map<String, dynamic>;
    final frames = summary['frame_count'] as int;
    final p90 = summary['90th_percentile_frame_build_time_millis'] as num;
    final missed = summary['missed_frame_build_budget_count'] as int;
    debugPrint(
      'Images : $frames · construction p90 : $p90 ms · '
      'hors budget (16 ms) : $missed',
    );

    expect(frames, greaterThan(0));
    // En debug (JIT, assertions) les temps ne sont pas représentatifs.
    if (kProfileMode) {
      // 60 fps : 90 % des images construites en moins de 16 ms…
      expect(p90, lessThan(16));
      // … et au plus 5 % d'images hors budget (aucun jank visible).
      expect(missed / frames, lessThan(0.05));
    }
  });
}
