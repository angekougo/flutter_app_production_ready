import 'package:flutter_app_production_ready/shared/widgets/star_text.dart';
import 'package:flutter_test/flutter_test.dart';

/// Trouve un [StarText] par son texte d'origine (« 2024 · ★ 8,2 ») :
/// l'étoile y est une icône, que `find.text` ne sait pas relire.
Finder findStarText(String data) => find.byWidgetPredicate(
  (widget) => widget is StarText && widget.data == data,
  description: 'StarText « $data »',
);
