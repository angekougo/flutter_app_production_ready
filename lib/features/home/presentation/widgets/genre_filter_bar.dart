import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/extensions/l10n_x.dart';
import '../../../movies/domain/entities/genre.dart';

/// Pastilles « Tous · Drame · Thriller · Comédie… » défilantes.
class GenreFilterBar extends StatelessWidget {
  const GenreFilterBar({
    super.key,
    required this.genres,
    required this.selectedId,
    required this.onSelected,
  });

  final List<Genre> genres;
  final int? selectedId;
  final ValueChanged<int?> onSelected;

  @override
  Widget build(BuildContext context) {
    final items = <(int?, String)>[
      (null, context.l10n.genreAll),
      for (final g in genres) (g.id, g.name),
    ];

    return SizedBox(
      height: AppDimensions.chipHeight + 4,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: AppDimensions.screenPadding,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppDimensions.sm),
        itemBuilder: (context, index) {
          final (id, label) = items[index];
          final selected = id == selectedId;
          return ChoiceChip(
            label: Text(label),
            selected: selected,
            onSelected: (_) => onSelected(id),
            labelStyle: AppTypography.label.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: selected ? AppColors.onProjecteur : AppColors.papier,
            ),
            side: BorderSide(
              color: selected ? AppColors.projecteur : AppColors.trait,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.lg,
              vertical: AppDimensions.sm,
            ),
          );
        },
      ),
    );
  }
}
