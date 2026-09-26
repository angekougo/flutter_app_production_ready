import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_dimensions.dart';
import '../../app/theme/app_typography.dart';
import '../../core/network/api_constants.dart';
import '../extensions/image_x.dart';
import '../extensions/l10n_x.dart';

/// Affiche d'un film (ratio 2:3).
///
/// Sans image (pas d'affiche TMDB, chargement, hors ligne sans cache
/// d'image), affiche une teinte propre au film avec son titre, comme le
/// placeholder du design.
class PosterCard extends StatelessWidget {
  const PosterCard({
    super.key,
    required this.movieId,
    required this.title,
    this.posterPath,
    this.rating,
    this.topRight,
    this.onTap,
    this.titleStyle,
    this.width,
    this.showPlaceholderTitle = true,
    this.semanticLabel,
  });

  /// Texte lu par les lecteurs d'écran (par défaut : titre et note). Le
  /// visuel (image, titre du placeholder, badge) n'est pas lu en plus.
  final String? semanticLabel;

  final int movieId;
  final String title;
  final String? posterPath;

  /// Note affichée en badge (masquée si `null`).
  final double? rating;

  /// Remplace le badge de note (ex. cœur des favoris).
  final Widget? topRight;
  final VoidCallback? onTap;
  final TextStyle? titleStyle;
  final double? width;

  ///  pour les vignettes trop petites pour afficher un titre.
  final bool showPlaceholderTitle;

  @override
  Widget build(BuildContext context) {
    final tint = AppColors.posterTint(movieId);
    final radius = BorderRadius.circular(AppDimensions.radiusMd);
    final placeholder = _Placeholder(
      tint: tint,
      title: showPlaceholderTitle ? title : null,
      style: titleStyle,
    );

    // Le badge de note est décrit par le libellé ; un bouton personnalisé
    // (retrait des favoris) reste accessible séparément.
    final badge =
        topRight ??
        (rating == null
            ? null
            : ExcludeSemantics(child: RatingBadge(rating: rating!)));

    return Semantics(
      button: onTap != null,
      label: semanticLabel ?? context.l10n.movieSummary(title, rating: rating),
      child: SizedBox(
        width: width,
        child: AspectRatio(
          aspectRatio: AppDimensions.posterAspectRatio,
          child: Material(
            color: tint,
            shape: RoundedRectangleBorder(
              borderRadius: radius,
              side: BorderSide(
                color: Color.lerp(tint, AppColors.papier, 0.12)!,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ExcludeSemantics(
                    child: posterPath == null
                        ? placeholder
                        : LayoutBuilder(
                            // Téléchargée et décodée à la taille affichée.
                            builder: (context, constraints) {
                              final pixels = context.decodeWidth(
                                constraints.maxWidth,
                              );
                              return CachedNetworkImage(
                                imageUrl: ApiConstants.poster(
                                  posterPath,
                                  size: ApiConstants.posterSizeFor(pixels),
                                )!,
                                fit: BoxFit.cover,
                                memCacheWidth: pixels,
                                fadeInDuration: const Duration(
                                  milliseconds: 200,
                                ),
                                placeholder: (_, _) => placeholder,
                                errorWidget: (_, _, _) => placeholder,
                              );
                            },
                          ),
                  ),
                  if (badge != null)
                    Positioned(
                      top: AppDimensions.sm,
                      right: AppDimensions.sm,
                      child: badge,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.tint, this.title, this.style});

  final Color tint;
  final String? title;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    if (title == null) return ColoredBox(color: tint);
    return ColoredBox(
      color: tint,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.md),
          child: Text(
            title!,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: style ?? AppTypography.posterTitle,
          ),
        ),
      ),
    );
  }
}

/// « ★ 7,8 » sur fond sombre, en haut à droite des affiches.
class RatingBadge extends StatelessWidget {
  const RatingBadge({super.key, required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xE6120F0C),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm - 2),
      ),
      child: Text(
        '★ ${context.l10n.rating(rating)}',
        style: AppTypography.meta.copyWith(
          color: AppColors.projecteur,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
