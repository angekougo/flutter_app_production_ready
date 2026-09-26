import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Trois familles :
/// - Fraunces : titres (display, sections, titres originaux en italique) ;
/// - Manrope : corps de texte et interface ;
/// - IBM Plex Mono : méta-données (année, durée, note, étiquettes).
abstract final class AppTypography {
  // Fraunces 600 · 44
  static TextStyle get display => GoogleFonts.fraunces(
    fontSize: 44,
    fontWeight: FontWeight.w600,
    height: 1.1,
    letterSpacing: -0.5,
    color: AppColors.papier,
  );

  /// Titres d'écran : « Recherche », « Mes favoris », « Profil ».
  static TextStyle get screenTitle => display.copyWith(fontSize: 34);

  /// Logo « Cinéthèque » dans l'en-tête de l'accueil.
  static TextStyle get brand => display.copyWith(fontSize: 30);

  // Fraunces 600 · 22
  static TextStyle get section => GoogleFonts.fraunces(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: AppColors.papier,
  );

  /// Titre posé en bas d'une affiche.
  static TextStyle get posterTitle =>
      section.copyWith(fontSize: 16, height: 1.15);

  // Fraunces italique · 18
  static TextStyle get originalTitle => GoogleFonts.fraunces(
    fontSize: 18,
    fontStyle: FontStyle.italic,
    color: AppColors.poussiere,
  );

  // Manrope 400 · 15 / 1.6
  static TextStyle get body => GoogleFonts.manrope(
    fontSize: 15,
    height: 1.6,
    color: AppColors.poussiere,
  );

  static TextStyle get bodyStrong => GoogleFonts.manrope(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.papier,
  );

  static TextStyle get label => GoogleFonts.manrope(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.papier,
  );

  static TextStyle get button =>
      GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w700);

  static TextStyle get caption =>
      GoogleFonts.manrope(fontSize: 13, color: AppColors.poussiere);

  // IBM Plex Mono 500 · 12
  static TextStyle get meta => GoogleFonts.ibmPlexMono(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.2,
    color: AppColors.poussiere,
  );

  /// Étiquette en capitales espacées (« BONSOIR, AWA », « TITRE DU FILM »).
  static TextStyle get overline => meta.copyWith(letterSpacing: 2.4);
}
