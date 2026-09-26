import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_dimensions.dart';
import '../../app/theme/app_typography.dart';
import '../extensions/l10n_x.dart';

/// Bannière « Hors connexion — affichage des dernières données disponibles. »
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key, this.cachedAt});

  /// Date de la dernière mise à jour du cache, si connue.
  final DateTime? cachedAt;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // Annoncée par les lecteurs d’écran dès qu’elle apparaît.
    return Semantics(
      container: true,
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimensions.lg),
        decoration: BoxDecoration(
          color: AppColors.offlineBackground,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(color: AppColors.offlineBorder),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.wifi_off_rounded, color: AppColors.nuit, size: 22),
            const SizedBox(width: AppDimensions.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.offlineBanner,
                    style: AppTypography.bodyStrong.copyWith(
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                  if (cachedAt != null) ...[
                    const SizedBox(height: AppDimensions.xs),
                    Text(
                      l10n.offlineUpdated(
                        l10n.timeAgo(cachedAt!).toUpperCase(),
                      ),
                      style: AppTypography.overline.copyWith(
                        color: AppColors.nuit,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
