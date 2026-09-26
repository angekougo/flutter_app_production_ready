import 'package:integration_test/integration_test_driver.dart';

/// Pilote de `flutter drive` : enregistre les mesures du test de
/// performance dans build/scrolling_summary.json.
Future<void> main() => integrationDriver(
  responseDataCallback: (data) async {
    if (data == null) return;
    await writeResponseData(
      data['scrolling'] as Map<String, dynamic>,
      testOutputFilename: 'scrolling_summary',
    );
  },
);
