import 'package:flutter/material.dart';

import '../../app/theme/app_dimensions.dart';
import '../../app/theme/app_typography.dart';
import 'poster_card.dart';

/// Grille d'affiches à 3 colonnes (« Tout voir », filmographie).
///
/// La hauteur d'une case dépend de la largeur de l'écran (affiche 2:3) et
/// de la taille de texte choisie par l'utilisateur : elle est calculée
/// plutôt que fixée par un ratio, pour ne jamais déborder.
class SliverPosterGrid extends StatelessWidget {
  const SliverPosterGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.columns = 3,
  });

  final int columns;

  final int itemCount;
  final PosterGridItem Function(BuildContext context, int index) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final itemWidth =
            (constraints.crossAxisExtent - (columns - 1) * AppDimensions.md) /
            columns;
        return SliverGrid.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: AppDimensions.md,
            mainAxisSpacing: AppDimensions.lg,
            mainAxisExtent: PosterGridItem.extentFor(context, itemWidth),
          ),
          itemCount: itemCount,
          itemBuilder: itemBuilder,
        );
      },
    );
  }
}

/// Affiche + titre + ligne de méta-données (« 2024 · ★ 8,2 »).
class PosterGridItem extends StatelessWidget {
  const PosterGridItem({
    super.key,
    required this.movieId,
    required this.title,
    required this.caption,
    this.posterPath,
    this.onTap,
    this.topRight,
    this.semanticLabel,
  });

  final int movieId;
  final String title;
  final String caption;
  final String? posterPath;
  final VoidCallback? onTap;

  /// Badge en haut à droite de l'affiche (ex. cœur des favoris).
  final Widget? topRight;

  /// Résumé lu par les lecteurs d'écran (titre, année, note…) ; le titre
  /// et la légende affichés sous l'affiche ne sont alors pas relus.
  final String? semanticLabel;

  static TextStyle get _titleStyle =>
      AppTypography.label.copyWith(fontSize: 13);
  static TextStyle get _captionStyle =>
      AppTypography.meta.copyWith(fontSize: 11, letterSpacing: 0.5);

  /// Hauteur exacte d'une case : affiche + espacement + deux lignes de texte
  /// mesurées avec le facteur de taille de texte de l'appareil.
  static double extentFor(BuildContext context, double width) {
    final scaler = MediaQuery.textScalerOf(context);
    // Style réellement appliqué : le Text hérite du DefaultTextStyle du thème
    // (dont la hauteur de ligne), qu'il faut inclure dans la mesure.
    final inherited = DefaultTextStyle.of(context).style;
    double lineHeight(TextStyle style) {
      final painter = TextPainter(
        text: TextSpan(text: 'Ag', style: inherited.merge(style)),
        textScaler: scaler,
        textDirection: TextDirection.ltr,
        maxLines: 1,
      )..layout();
      final height = painter.height;
      painter.dispose();
      return height;
    }

    return (width / AppDimensions.posterAspectRatio +
            AppDimensions.sm +
            lineHeight(_titleStyle) +
            lineHeight(_captionStyle))
        .ceilToDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PosterCard(
          movieId: movieId,
          title: title,
          posterPath: posterPath,
          titleStyle: AppTypography.posterTitle.copyWith(fontSize: 14),
          onTap: onTap,
          topRight: topRight,
          semanticLabel: semanticLabel ?? [title, caption].join(', '),
        ),
        const SizedBox(height: AppDimensions.sm),
        ExcludeSemantics(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _titleStyle,
          ),
        ),
        if (caption.isNotEmpty)
          ExcludeSemantics(
            child: Text(
              caption,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _captionStyle,
            ),
          ),
      ],
    );
  }
}
