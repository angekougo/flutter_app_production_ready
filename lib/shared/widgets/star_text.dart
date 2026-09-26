import 'package:flutter/material.dart';

/// Texte dont chaque « ★ » est dessiné avec l'icône Material étoile.
///
/// Aucune police de l'application ne contient le caractère ★ : son rendu
/// dépendrait de la police de secours du système (différente, voire absente,
/// selon l'appareil). La police d'icônes Material est toujours embarquée.
class StarText extends StatelessWidget {
  const StarText(
    this.data, {
    super.key,
    this.style,
    this.maxLines,
    this.overflow,
    this.semanticsLabel,
  });

  static const star = '★';

  final String data;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final parts = data.split(star);
    if (parts.length == 1) {
      return Text(
        data,
        style: style,
        maxLines: maxLines,
        overflow: overflow,
        semanticsLabel: semanticsLabel,
      );
    }

    final effective = DefaultTextStyle.of(context).style.merge(style);
    final size = (effective.fontSize ?? 14) * 1.1;
    return Text.rich(
      TextSpan(
        children: [
          for (final (i, part) in parts.indexed) ...[
            if (i > 0)
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Icon(
                  Icons.star_rounded,
                  size: size,
                  color: effective.color,
                ),
              ),
            TextSpan(text: part),
          ],
        ],
      ),
      style: style,
      maxLines: maxLines,
      overflow: overflow,
      // Lecteurs d'écran : le texte d'origine (sans caractère de substitution).
      semanticsLabel: semanticsLabel ?? data,
    );
  }
}
