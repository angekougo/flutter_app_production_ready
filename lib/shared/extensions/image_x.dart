import 'package:flutter/widgets.dart';

extension ImageDecodeX on BuildContext {
  /// Largeur de décodage (pixels physiques) d'une image affichée sur
  /// [logicalWidth] dp : l'image n'est jamais décodée plus grande qu'à
  /// l'écran, ce qui économise mémoire et temps de décodage (jank).
  int decodeWidth(double logicalWidth) =>
      (logicalWidth * MediaQuery.devicePixelRatioOf(this)).ceil();
}
