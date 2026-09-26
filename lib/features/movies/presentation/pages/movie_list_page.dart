import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/extensions/async_value_x.dart';
import '../../../../shared/extensions/l10n_x.dart';
import '../../../../shared/widgets/offline_banner.dart';
import '../../../../shared/widgets/poster_grid.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../../../shared/widgets/state_message_view.dart';
import '../../domain/entities/movie_category.dart';
import '../providers/movie_list_controller.dart';

/// « Tout voir » : grille paginée d'une catégorie (défilement infini).
class MovieListPage extends ConsumerWidget {
  const MovieListPage({super.key, required this.category});

  final MovieCategory category;

  /// Distance au bas de la liste qui déclenche la page suivante.
  static const _loadMoreThreshold = 600.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = movieListControllerProvider(category);
    bool onScroll(ScrollNotification notification) {
      if (notification.metrics.extentAfter < _loadMoreThreshold) {
        ref.read(provider.notifier).loadMore();
      }
      return false;
    }

    void retryLoadMore() => ref.read(provider.notifier).loadMore();

    final state = ref.watch(provider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.categoryLabel(category),
          style: AppTypography.section.copyWith(fontSize: 26),
        ),
        titleSpacing: 0,
      ),
      body: switch (state) {
        AsyncValue(:final value?) => RefreshIndicator(
          color: AppColors.projecteur,
          backgroundColor: AppColors.salle,
          onRefresh: () => ref.refresh(provider.future),
          child: NotificationListener<ScrollNotification>(
            onNotification: onScroll,
            child: _Grid(state: value, onRetry: retryLoadMore),
          ),
        ),
        AsyncValue(:final failure?) => StateMessageView(
          tone: StateTone.error,
          icon: Icons.movie_filter_outlined,
          title: context.l10n.loadErrorTitle,
          message: context.l10n.failureMessage(failure),
          primaryLabel: context.l10n.retry,
          onPrimary: () => ref.invalidate(provider),
        ),
        _ => const _GridSkeleton(),
      },
    );
  }
}

class _Grid extends StatelessWidget {
  const _Grid({required this.state, required this.onRetry});

  final PagedMovies state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        if (state.fromCache)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.gutter,
              AppDimensions.sm,
              AppDimensions.gutter,
              AppDimensions.lg,
            ),
            sliver: SliverToBoxAdapter(
              child: OfflineBanner(cachedAt: state.cachedAt),
            ),
          ),
        SliverPadding(
          padding: AppDimensions.screenPadding,
          sliver: SliverPosterGrid(
            itemCount: state.movies.length,
            itemBuilder: (context, index) {
              final movie = state.movies[index];
              return PosterGridItem(
                movieId: movie.id,
                title: movie.title,
                posterPath: movie.posterPath,
                caption: [
                  if (movie.year != null) '${movie.year}',
                  if (movie.hasRating)
                    '★ ${context.l10n.rating(movie.voteAverage)}',
                ].join(' · '),
                semanticLabel: context.l10n.movieSummary(
                  movie.title,
                  year: movie.year,
                  rating: movie.hasRating ? movie.voteAverage : null,
                ),
                onTap: () =>
                    context.push(RoutePaths.movie(movie.id), extra: movie),
              );
            },
          ),
        ),
        SliverToBoxAdapter(
          child: _Footer(state: state, onRetry: onRetry),
        ),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.state, required this.onRetry});

  final PagedMovies state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final Widget child;
    if (state.isLoadingMore) {
      child = const SizedBox.square(
        dimension: 28,
        child: CircularProgressIndicator(strokeWidth: 2.5),
      );
    } else if (state.loadMoreFailure case final failure?) {
      child = Column(
        children: [
          Text(
            context.l10n.failureMessage(failure),
            textAlign: TextAlign.center,
            style: AppTypography.body.copyWith(color: AppColors.signal),
          ),
          TextButton(onPressed: onRetry, child: Text(context.l10n.retry)),
        ],
      );
    } else if (!state.hasMore) {
      child = Text(
        context.l10n.listEnd(state.movies.length),
        style: AppTypography.overline,
      );
    } else {
      child = const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.gutter,
        vertical: AppDimensions.xl,
      ),
      child: Center(child: child),
    );
  }
}

class _GridSkeleton extends StatelessWidget {
  const _GridSkeleton();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: AppDimensions.screenPadding,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: AppDimensions.md,
        mainAxisSpacing: AppDimensions.lg,
        childAspectRatio: AppDimensions.posterAspectRatio,
      ),
      itemCount: 12,
      itemBuilder: (_, _) => const SkeletonBox(),
    );
  }
}
