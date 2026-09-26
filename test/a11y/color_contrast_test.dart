import 'dart:math' as math;

import 'package:flutter/painting.dart';
import 'package:flutter_app_production_ready/app/theme/app_colors.dart';
import 'package:flutter_test/flutter_test.dart';

/// Rapport de contraste WCAG 2.x entre deux couleurs opaques.
double contrastRatio(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

/// Chaque couleur de texte de l'application, sur chaque fond où elle
/// apparaît, respecte le niveau AA des WCAG (4,5:1 pour le texte courant).
void main() {
  const textColors = {
    'papier (texte principal)': AppColors.papier,
    'poussière (texte secondaire)': AppColors.poussiere,
    'projecteur (accent, notes)': AppColors.projecteur,
    'nuit (hors connexion)': AppColors.nuit,
    'signal (erreurs)': AppColors.signal,
    'menthe (succès)': AppColors.menthe,
  };
  const backgrounds = {
    'encre': AppColors.encre,
    'salle': AppColors.salle,
    'velours': AppColors.velours,
    'bannière hors ligne': AppColors.offlineBackground,
  };

  for (final MapEntry(key: textName, value: text) in textColors.entries) {
    test('$textName : contraste AA sur tous les fonds', () {
      for (final MapEntry(key: bgName, value: bg) in backgrounds.entries) {
        expect(
          contrastRatio(text, bg),
          greaterThanOrEqualTo(4.5),
          reason: '$textName sur $bgName',
        );
      }
    });
  }

  test('texte des boutons principaux lisible sur l’accent', () {
    expect(
      contrastRatio(AppColors.onProjecteur, AppColors.projecteur),
      greaterThanOrEqualTo(4.5),
    );
  });

  test('calcul de référence : noir sur blanc = 21:1', () {
    expect(
      contrastRatio(const Color(0xFF000000), const Color(0xFFFFFFFF)),
      closeTo(21, 0.01),
    );
  });
}
