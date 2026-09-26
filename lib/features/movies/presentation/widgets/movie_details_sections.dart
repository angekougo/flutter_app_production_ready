import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../shared/extensions/format_x.dart';
import '../../../../shared/extensions/image_x.dart';
import '../../../../shared/extensions/l10n_x.dart';
import '../../../../shared/widgets/person_avatar.dart';
import '../../../../shared/widgets/poster_card.dart';
import '../../../../shared/widgets/star_text.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_details.dart';

/// Image de fond + affiche qui chevauche + titre et titre original.
class MovieDetailsHeader extends StatelessWidget {
  const MovieDetailsHeader({super.key, required this.movie});

  static const backdropHeight = 250.0;
  static const posterWidth = 124.0;

  /// Partie de l'affiche qui remonte sur l'image de fond.
  static const posterOverlap = 110.0;

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final tint = AppColors.posterTint(movie.id);
    final backdropPixels = context.decodeWidth(
      MediaQuery.sizeOf(context).width,
    );
    final backdrop = ApiConstants.backdrop(
      movie.backdropPath,
      size: ApiConstants.backdropSizeFor(backdropPixels),
    );
    final showOriginal =
        movie.originalTitle != null &&
        movie.originalTitle!.toLowerCase() != movie.title.toLowerCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: backdropHeight,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ColoredBox(color: tint),
              if (backdrop != null)
                CachedNetworkImage(
                  imageUrl: backdrop,
                  fit: BoxFit.cover,
                  memCacheWidth: backdropPixels,
                  errorWidget: (_, _, _) => const SizedBox.shrink(),
                ),
              // Fondu vers le fond de l'écran.
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x660E0D0B),
                      Color(0x000E0D0B),
                      AppColors.encre,
                    ],
                    stops: [0, 0.4, 1],
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: AppDimensions.screenPadding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // L'affiche déborde vers le haut sur l'image de fond.
              SizedBox(
                width: posterWidth,
                height: posterWidth * 1.5 - posterOverlap,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: -posterOverlap,
                      left: 0,
                      width: posterWidth,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusMd,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x99000000),
                              blurRadius: 24,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: PosterCard(
                          movieId: movie.id,
                          title: movie.title,
                          posterPath: movie.posterPath,
                          titleStyle: AppTypography.posterTitle.copyWith(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.lg),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: AppDimensions.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: AppTypography.display.copyWith(fontSize: 28),
                      ),
                      if (showOriginal) ...[
                        const SizedBox(height: AppDimensions.xs),
                        Text(
                          movie.originalTitle!,
                          style: AppTypography.originalTitle,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Bandeau SORTIE · DURÉE · NOTE · POPULARITÉ entre deux filets.
class MovieStatsBar extends StatelessWidget {
  const MovieStatsBar({super.key, required this.movie, this.runtime});

  final Movie movie;
  final int? runtime;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final valueStyle = AppTypography.meta.copyWith(
      color: AppColors.papier,
      fontSize: 15,
      letterSpacing: 0.5,
    );
    // Chaque statistique est lue d’un bloc : « NOTE, note 8,2 sur 10 ».
    Widget stat(
      String label,
      String value, {
      Color? color,
      String? semanticValue,
    }) => Expanded(
      child: MergeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Une seule ligne : un libellé long (« POPULARITÉ ») est réduit
            // plutôt que coupé en deux sur les écrans étroits.
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                label,
                maxLines: 1,
                style: AppTypography.overline.copyWith(fontSize: 11),
              ),
            ),
            const SizedBox(height: AppDimensions.sm),
            StarText(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              semanticsLabel: semanticValue,
              style: valueStyle.copyWith(color: color),
            ),
          ],
        ),
      ),
    );

    return Padding(
      padding: AppDimensions.screenPadding,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.lg),
        decoration: const BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(color: AppColors.trait),
          ),
        ),
        child: Row(
          children: [
            stat(
              l10n.statRelease,
              movie.releaseDate == null
                  ? l10n.notAvailable
                  : l10n.shortDate(movie.releaseDate!),
            ),
            stat(l10n.statRuntime, runtime?.asRuntime ?? l10n.notAvailable),
            stat(
              l10n.statRating,
              movie.hasRating
                  ? '★ ${l10n.rating(movie.voteAverage)}'
                  : l10n.notAvailable,
              semanticValue: movie.hasRating
                  ? l10n.a11yRating(l10n.rating(movie.voteAverage))
                  : null,
              color: movie.hasRating ? AppColors.projecteur : null,
            ),
            stat(l10n.statPopularity, l10n.popularity(movie.popularity)),
          ],
        ),
      ),
    );
  }
}

/// Pastilles de genres (non interactives).
class GenrePills extends StatelessWidget {
  const GenrePills({super.key, required this.genres});

  final List<String> genres;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppDimensions.screenPadding,
      child: Wrap(
        spacing: AppDimensions.sm,
        runSpacing: AppDimensions.sm,
        children: [
          for (final genre in genres)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.lg,
                vertical: AppDimensions.sm + 2,
              ),
              decoration: BoxDecoration(
                color: AppColors.salle,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: AppColors.trait),
              ),
              child: Text(
                genre,
                style: AppTypography.label.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Acteur du casting : portrait rond, nom, personnage.
class CastMemberTile extends StatelessWidget {
  const CastMemberTile({super.key, required this.member, required this.onTap});

  static const width = 88.0;

  final CastMember member;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      excludeSemantics: true,
      onTap: onTap,
      label: switch (member.character) {
        final character? => context.l10n.a11yCastMember(member.name, character),
        null => member.name,
      },
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: SizedBox(
          width: width,
          child: Column(
            children: [
              PersonAvatar(
                personId: member.id,
                initials: member.initials,
                profilePath: member.profilePath,
                size: 80,
              ),
              const SizedBox(height: AppDimensions.sm),
              Text(
                member.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.label.copyWith(
                  fontWeight: FontWeight.w500,
                  height: 1.25,
                ),
              ),
              if (member.character != null) ...[
                const SizedBox(height: 2),
                Text(
                  member.character!,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.caption,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
