import 'package:flutter/material.dart';

/// Palette « Salle obscure » : encre chaude en fond, lumière de projecteur en
/// accent. Les affiches TMDB portent la couleur ; l'interface reste en retrait.
abstract final class AppColors {
  // Fonds & surfaces
  static const encre = Color(0xFF0E0D0B); // fond
  static const salle = Color(0xFF1A1815); // surfaces, champs
  static const velours = Color(0xFF25221D); // surfaces hautes
  static const trait = Color(0xFF34302A); // bordures

  // Texte
  static const papier = Color(0xFFF2EBDD); // texte principal
  static const poussiere = Color(0xFFA89F8F); // texte secondaire

  // Sémantique
  static const projecteur = Color(0xFFE9A23B); // accent, action, note
  static const nuit = Color(0xFF8AB4E0); // hors connexion, info
  static const signal = Color(0xFFE5735A); // erreurs
  static const menthe = Color(0xFF7FC79A); // succès, session active

  // Dérivées
  static const onProjecteur = Color(0xFF1A1206);
  static const navBar = Color(0xFF131210);
  static const offlineBackground = Color(0xFF16202A);
  static const offlineBorder = Color(0xFF223246);
  static const signalBorder = Color(0xFF4A2A22);

  /// Teintes de repli pour les affiches absentes (placeholder TMDB),
  /// choisies de façon déterministe à partir de l'id du film.
  static const posterTints = [
    Color(0xFF391E27), // lie-de-vin
    Color(0xFF203341), // bleu marée
    Color(0xFF3D3520), // olive
    Color(0xFF3B2A20), // brun
    Color(0xFF213029), // vert sapin
    Color(0xFF2B253F), // violet
    Color(0xFF3F2622), // brique
    Color(0xFF1C2230), // bleu nuit
  ];

  static Color posterTint(int seed) =>
      posterTints[seed.abs() % posterTints.length];
}
