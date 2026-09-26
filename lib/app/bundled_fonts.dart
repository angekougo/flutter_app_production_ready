import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Polices embarquées dans `assets/google_fonts/` : l'application ne les
/// télécharge jamais (premier lancement hors ligne, confidentialité), et
/// leurs licences OFL figurent dans l'écran des licences.
void useBundledFonts() {
  GoogleFonts.config.allowRuntimeFetching = false;
  LicenseRegistry.addLicense(() async* {
    for (final family in const ['Manrope', 'Fraunces', 'IBMPlexMono']) {
      yield LicenseEntryWithLineBreaks([
        family,
      ], await rootBundle.loadString('assets/google_fonts/OFL-$family.txt'));
    }
  });
}
