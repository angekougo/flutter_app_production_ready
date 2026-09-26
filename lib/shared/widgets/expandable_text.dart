import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_dimensions.dart';
import '../../app/theme/app_typography.dart';
import '../extensions/l10n_x.dart';

/// Texte long replié sur [maxLines] lignes, avec « Lire la suite ».
/// Le bouton n'apparaît que si le texte dépasse réellement.
class ExpandableText extends HookWidget {
  const ExpandableText(this.text, {super.key, this.maxLines = 5, this.style});

  final String text;
  final int maxLines;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final expanded = useState(false);
    final style = DefaultTextStyle.of(context).style
        .merge(this.style ?? AppTypography.body);

    return LayoutBuilder(
      builder: (context, constraints) {
        final painter = TextPainter(
          text: TextSpan(text: text, style: style),
          maxLines: maxLines,
          textDirection: Directionality.of(context),
          textScaler: MediaQuery.textScalerOf(context),
        )..layout(maxWidth: constraints.maxWidth);
        final overflows = painter.didExceedMaxLines;
        painter.dispose();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              alignment: Alignment.topCenter,
              child: Text(
                text,
                style: style,
                maxLines: expanded.value ? null : maxLines,
                overflow: expanded.value ? null : TextOverflow.ellipsis,
              ),
            ),
            if (overflows)
              Padding(
                padding: const EdgeInsets.only(top: AppDimensions.sm),
                child: TextButton(
                  onPressed: () => expanded.value = !expanded.value,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size.square(AppDimensions.minTapTarget),
                  ),
                  child: Text(
                    expanded.value
                        ? context.l10n.readLess
                        : context.l10n.readMore,
                    style: AppTypography.button.copyWith(
                      color: AppColors.projecteur,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
