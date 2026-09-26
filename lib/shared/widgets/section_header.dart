import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_dimensions.dart';
import '../../app/theme/app_typography.dart';

/// « Populaires ······ Tout voir » ou « Tendances ······ EN CACHE ».
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
    this.tag,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  /// Étiquette monospace à droite (« EN CACHE », « 23 FILMS »).
  final String? tag;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppDimensions.screenPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTypography.section.copyWith(fontSize: 26),
            ),
          ),
          if (tag != null)
            Text(tag!, style: AppTypography.overline)
          else if (actionLabel != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 36),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                actionLabel!,
                style: AppTypography.button.copyWith(
                  color: AppColors.projecteur,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
