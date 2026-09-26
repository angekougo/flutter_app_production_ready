import 'package:flutter/widgets.dart';

abstract final class AppDimensions {
  // Espacements
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;

  /// Gouttière latérale des écrans.
  static const gutter = 20.0;
  static const screenPadding = EdgeInsets.symmetric(horizontal: gutter);

  // Rayons
  static const radiusSm = 8.0;
  static const radiusMd = 12.0;
  static const radiusLg = 16.0;

  // Composants
  static const buttonHeight = 52.0;
  static const chipHeight = 44.0;
  static const iconButtonSize = 48.0;

  /// Carte affiche des carrousels (ratio 2:3).
  static const posterWidth = 112.0;
  static const posterHeight = 168.0;
  static const posterAspectRatio = 2 / 3;

  /// Cercle d'icône des états vides / d'erreur.
  static const stateIconCircle = 104.0;
}
