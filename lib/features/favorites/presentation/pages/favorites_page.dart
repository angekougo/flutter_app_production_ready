import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/result/result.dart';
import '../../../../shared/extensions/async_value_x.dart';
import '../../../../shared/extensions/l10n_x.dart';
import '../../../../shared/widgets/app_snack_bar.dart';
import '../../../../shared/widgets/poster_grid.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../../../shared/widgets/state_message_view.dart';
import '../../domain/entities/favorite.dart';
import '../providers/favorites_providers.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  Future<void> _remove(
    BuildContext context,
    WidgetRef ref,
    Favorite favorite,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final actions = ref.read(favoriteActionsProvider);
    final result = await actions.remove(favorite);
    switch (result) {
      case Success():
        showAppSnackBar(
          messenger,
          l10n.favoriteRemovedNamed(favorite.title),
          actionLabel: l10n.undo,
          onAction: () => actions.restore(favorite),
        );
      case Error(:final failure):
        showAppSnackBar(
          messenger,
          l10n.failureMessage(failure),
          tone: SnackTone.error,
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final l10n = context.l10n;

    final Widget body = switch (favorites) {
      AsyncValue(:final value?) when value.isEmpty => StateMessageView(
        icon: Icons.favorite_border_rounded,
        title: l10n.favoritesEmptyTitle,
        message: l10n.favoritesEmptyMessage,
        primaryLabel: l10n.favoritesDiscover,
        onPrimary: () => context.go(RoutePaths.home),
        expandPrimary: false,
      ),
      AsyncValue(:final value?) => _FavoritesGrid(
        favorites: value,
        onRemove: (f) => _remove(context, ref, f),
      ),
      AsyncValue(:final failure?) => StateMessageView(
        tone: StateTone.error,
        icon: Icons.favorite_border_rounded,
        title: l10n.favoritesLoadError,
        message: l10n.failureMessage(failure),
        primaryLabel: l10n.retry,
        onPrimary: () => ref.invalidate(favoritesProvider),
      ),
      _ => const _FavoritesSkeleton(),
    };

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.gutter,
                AppDimensions.lg,
                AppDimensions.gutter,
                0,
              ),
              child: Semantics(
                header: true,
                child: Text(
                  l10n.favoritesTitle,
                  style: AppTypography.screenTitle,
                ),
              ),
            ),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}

class _FavoritesGrid extends StatelessWidget {
  const _FavoritesGrid({required this.favorites, required this.onRemove});

  final List<Favorite> favorites;
  final ValueChanged<Favorite> onRemove;

  @override
  Widget build(BuildContext context) {
    final count = favorites.length;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.gutter,
            AppDimensions.md,
            AppDimensions.gutter,
            AppDimensions.xl,
          ),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                const Icon(
                  Icons.download_rounded,
                  color: AppColors.menthe,
                  size: 20,
                ),
                const SizedBox(width: AppDimensions.sm),
                Expanded(
                  child: Text(
                    context.l10n.favoritesOfflineCount(count),
                    style: AppTypography.body.copyWith(height: 1.3),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: AppDimensions.screenPadding,
          sliver: SliverPosterGrid(
            columns: 2,
            itemCount: count,
            itemBuilder: (context, index) {
              final favorite = favorites[index];
              return PosterGridItem(
                movieId: favorite.movieId,
                title: favorite.title,
                posterPath: favorite.posterPath,
                caption: [
                  if (favorite.year != null) '${favorite.year}',
                  if (favorite.voteAverage > 0)
                    '★ ${context.l10n.rating(favorite.voteAverage)}',
                ].join(' · '),
                semanticLabel: context.l10n.movieSummary(
                  favorite.title,
                  year: favorite.year,
                  rating: favorite.voteAverage > 0
                      ? favorite.voteAverage
                      : null,
                ),
                onTap: () => context.push(
                  RoutePaths.movie(favorite.movieId),
                  extra: favorite.toMovie(),
                ),
                topRight: _RemoveButton(onPressed: () => onRemove(favorite)),
              );
            },
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppDimensions.xxl)),
      ],
    );
  }
}

/// Cœur plein dans un cercle sombre : retire le film des favoris.
class _RemoveButton extends StatelessWidget {
  const _RemoveButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: context.l10n.favoriteRemove,
      onPressed: onPressed,
      icon: const Icon(Icons.favorite_rounded, size: 22),
      style: IconButton.styleFrom(
        fixedSize: const Size.square(44),
        foregroundColor: AppColors.projecteur,
        backgroundColor: AppColors.encre.withValues(alpha: 0.85),
      ),
    );
  }
}

class _FavoritesSkeleton extends StatelessWidget {
  const _FavoritesSkeleton();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppDimensions.gutter),
      crossAxisCount: 2,
      crossAxisSpacing: AppDimensions.md,
      mainAxisSpacing: AppDimensions.lg,
      childAspectRatio: AppDimensions.posterAspectRatio,
      children: [for (var i = 0; i < 4; i++) const SkeletonBox()],
    );
  }
}
