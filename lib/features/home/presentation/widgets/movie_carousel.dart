import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/widgets/poster_card.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../../movies/domain/entities/movie.dart';

/// Rangée horizontale d'affiches.
class MovieCarousel extends StatelessWidget {
  const MovieCarousel({
    super.key,
    required this.movies,
    required this.onMovieTap,
    this.showRatings = true,
  });

  static const posterWidth = 128.0;
  static const height = posterWidth * 3 / 2;

  final List<Movie> movies;
  final ValueChanged<Movie> onMovieTap;
  final bool showRatings;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: AppDimensions.screenPadding,
        itemCount: movies.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppDimensions.md),
        itemBuilder: (context, index) {
          final movie = movies[index];
          return PosterCard(
            width: posterWidth,
            movieId: movie.id,
            title: movie.title,
            posterPath: movie.posterPath,
            rating: showRatings && movie.hasRating ? movie.voteAverage : null,
            onTap: () => onMovieTap(movie),
          );
        },
      ),
    );
  }
}

class MovieCarouselSkeleton extends StatelessWidget {
  const MovieCarouselSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MovieCarousel.height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: AppDimensions.screenPadding,
        itemCount: 4,
        separatorBuilder: (_, _) => const SizedBox(width: AppDimensions.md),
        itemBuilder: (_, _) => const SkeletonBox(
          width: MovieCarousel.posterWidth,
          height: MovieCarousel.height,
        ),
      ),
    );
  }
}

/// Message discret à la place d'un carrousel vide ou en échec.
class CarouselMessage extends StatelessWidget {
  const CarouselMessage(this.message, {super.key, this.isError = false});

  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppDimensions.screenPadding,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimensions.lg),
        decoration: BoxDecoration(
          color: AppColors.salle,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(
            color: isError ? AppColors.signalBorder : AppColors.trait,
          ),
        ),
        child: Text(
          message,
          style: AppTypography.body.copyWith(
            color: isError ? AppColors.signal : AppColors.poussiere,
          ),
        ),
      ),
    );
  }
}
