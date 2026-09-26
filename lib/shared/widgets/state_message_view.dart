import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_dimensions.dart';
import '../../app/theme/app_typography.dart';

enum StateTone { neutral, error }

/// État plein écran : icône dans un cercle, titre, message et actions.
///
/// Utilisé pour « Impossible de charger les données. » (tone: error) et
/// « Aucun favori pour l'instant » (tone: neutral).
class StateMessageView extends StatelessWidget {
  const StateMessageView({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.tone = StateTone.neutral,
    this.primaryLabel,
    this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
    this.expandPrimary = true,
  });

  final IconData icon;
  final String title;
  final String message;
  final StateTone tone;
  final String? primaryLabel;
  final VoidCallback? onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  /// `false` pour un bouton principal ajusté à son contenu (état vide).
  final bool expandPrimary;

  @override
  Widget build(BuildContext context) {
    final isError = tone == StateTone.error;
    final accent = isError ? AppColors.signal : AppColors.projecteur;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.xxl + 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppDimensions.stateIconCircle,
              height: AppDimensions.stateIconCircle,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.salle,
                border: Border.all(
                  color: isError ? AppColors.signalBorder : AppColors.trait,
                ),
              ),
              child: Icon(icon, size: 36, color: accent),
            ),
            const SizedBox(height: AppDimensions.xxl),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.section.copyWith(fontSize: 26),
            ),
            const SizedBox(height: AppDimensions.lg),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.body,
            ),
            if (primaryLabel != null) ...[
              const SizedBox(height: AppDimensions.xxl),
              expandPrimary
                  ? FilledButton(
                      onPressed: onPrimary,
                      child: Text(primaryLabel!),
                    )
                  : FilledButton(
                      onPressed: onPrimary,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(0, AppDimensions.buttonHeight),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.xxl + 8,
                        ),
                      ),
                      child: Text(primaryLabel!),
                    ),
            ],
            if (secondaryLabel != null) ...[
              const SizedBox(height: AppDimensions.md),
              OutlinedButton(
                onPressed: onSecondary,
                child: Text(secondaryLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
