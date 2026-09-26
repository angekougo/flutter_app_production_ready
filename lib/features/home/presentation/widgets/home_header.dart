import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';

/// « BONSOIR, AWA » + « Cinéthèque » + bouton recherche.
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.greeting, this.onSearch});

  final String greeting;

  /// Masqué quand `null` (état d'erreur du design).
  final VoidCallback? onSearch;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.gutter,
        AppDimensions.lg,
        AppDimensions.gutter,
        0,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(greeting.toUpperCase(), style: AppTypography.overline),
                const SizedBox(height: AppDimensions.xs),
                Text(AppConstants.appName, style: AppTypography.brand),
              ],
            ),
          ),
          if (onSearch != null)
            IconButton(
              tooltip: 'Rechercher un film',
              onPressed: onSearch,
              icon: const Icon(Icons.search_rounded, size: 26),
              style: IconButton.styleFrom(
                fixedSize: const Size.square(AppDimensions.iconButtonSize),
                backgroundColor: AppColors.salle,
                foregroundColor: AppColors.papier,
                side: const BorderSide(color: AppColors.trait),
              ),
            ),
        ],
      ),
    );
  }
}
