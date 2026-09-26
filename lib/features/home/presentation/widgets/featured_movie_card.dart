import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../shared/extensions/format_x.dart';
import '../../../movies/domain/entities/movie.dart';

/// Carte « N°1 DES TENDANCES » en tête de l'accueil.
class FeaturedMovieCard extends StatelessWidget {
  const FeaturedMovieCard({
    super.key,
    required this.movie,
    required this.genreName,
    required this.onTap,
  });

  final Movie movie;
  final String? genreName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tint = AppColors.posterTint(movie.id);
    final backdrop = ApiConstants.backdrop(movie.backdropPath);
    final meta = [
      if (movie.year != null) '${movie.year}',
      if (genreName != null) genreName!.toUpperCase(),
      if (movie.hasRating) '★ ${movie.voteAverage.asRating}',
    ].join(' · ');

    return Padding(
      padding: AppDimensions.screenPadding,
      child: Material(
        color: tint,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg + 4),
          side: BorderSide(color: Color.lerp(tint, AppColors.papier, 0.12)!),
        ),
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            height: 210,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (backdrop != null)
                  CachedNetworkImage(
                    imageUrl: backdrop,
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(milliseconds: 250),
                    errorWidget: (_, _, _) => const SizedBox.shrink(),
                  ),
                // Voile pour la lisibilité du titre sur l'image.
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        tint.withValues(alpha: 0.15),
                        tint.withValues(alpha: 0.55),
                        const Color(0xF20E0D0B),
                      ],
                      stops: const [0, 0.45, 1],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppDimensions.xl - 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.md,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.encre,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusSm,
                          ),
                        ),
                        child: Text(
                          'N°1 DES TENDANCES',
                          style: AppTypography.overline.copyWith(
                            color: AppColors.projecteur,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        movie.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.display.copyWith(fontSize: 32),
                      ),
                      if (meta.isNotEmpty) ...[
                        const SizedBox(height: AppDimensions.sm),
                        Text(
                          meta,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.meta.copyWith(
                            color: AppColors.papier,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
