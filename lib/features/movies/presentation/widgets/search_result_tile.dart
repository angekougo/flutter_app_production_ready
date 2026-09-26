import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/extensions/l10n_x.dart';
import '../../../../shared/widgets/poster_card.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../../../shared/widgets/star_text.dart';
import '../../domain/entities/movie.dart';

/// Ligne de résultat : vignette, titre, « 2025 · Thriller », « ★ 6,8 », ›.
class SearchResultTile extends StatelessWidget {
  const SearchResultTile({
    super.key,
    required this.movie,
    required this.genreName,
    required this.onTap,
  });

  static const thumbnailWidth = 64.0;

  final Movie movie;
  final String? genreName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final subtitle = [
      if (movie.year != null) '${movie.year}',
      ?genreName,
    ].join(' · ');

    return Semantics(
      button: true,
      excludeSemantics: true,
      onTap: onTap,
      label: context.l10n.movieSummary(
        movie.title,
        year: movie.year,
        genre: genreName,
        rating: movie.hasRating ? movie.voteAverage : null,
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.gutter,
            vertical: AppDimensions.md,
          ),
          child: Row(
            children: [
              PosterCard(
                width: thumbnailWidth,
                movieId: movie.id,
                title: movie.title,
                posterPath: movie.posterPath,
                showPlaceholderTitle: false,
              ),
              const SizedBox(width: AppDimensions.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.section.copyWith(fontSize: 20),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: AppDimensions.xs),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.body.copyWith(height: 1.3),
                      ),
                    ],
                    if (movie.hasRating) ...[
                      const SizedBox(height: AppDimensions.xs),
                      StarText(
                        '★ ${context.l10n.rating(movie.voteAverage)}',
                        style: AppTypography.meta.copyWith(
                          color: AppColors.projecteur,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.poussiere,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchResultSkeleton extends StatelessWidget {
  const SearchResultSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.gutter,
        vertical: AppDimensions.md,
      ),
      child: Row(
        children: [
          SkeletonBox(
            width: SearchResultTile.thumbnailWidth,
            height: SearchResultTile.thumbnailWidth * 1.5,
          ),
          SizedBox(width: AppDimensions.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(height: 20, radius: 6),
                SizedBox(height: AppDimensions.sm),
                SkeletonBox(width: 120, height: 14, radius: 6),
                SizedBox(height: AppDimensions.sm),
                SkeletonBox(width: 56, height: 14, radius: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
