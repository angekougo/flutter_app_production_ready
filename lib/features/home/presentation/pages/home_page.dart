import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../shared/extensions/async_value_x.dart';
import '../../../../shared/widgets/offline_banner.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../../../shared/widgets/state_message_view.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../movies/domain/entities/movie.dart';
import '../../../movies/domain/entities/movie_category.dart';
import '../../../movies/presentation/providers/movie_providers.dart';
import '../providers/home_providers.dart';
import '../widgets/featured_movie_card.dart';
import '../widgets/genre_filter_bar.dart';
import '../widgets/home_header.dart';
import '../widgets/movie_carousel.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Retour du réseau : on remplace les données en cache par des fraîches.
    ref.listen(networkStatusProvider, (previous, next) {
      final cameBackOnline = previous?.value == false && next.value == true;
      if (cameBackOnline && ref.read(homeOverviewProvider).showsCachedData) {
        refreshHome(ref);
      }
    });

    final user = ref.watch(currentUserProvider);
    final greeting = [
      greetingFor(DateTime.now()),
      if (user != null) user.firstName,
    ].join(', ');
    final overview = ref.watch(homeOverviewProvider);

    if (overview.blockingFailure case final failure?) {
      return _HomeError(greeting: greeting, failure: failure);
    }

    void openSearch() => context.go(RoutePaths.search);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: AppColors.projecteur,
          backgroundColor: AppColors.salle,
          onRefresh: () => refreshHome(ref),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: HomeHeader(greeting: greeting, onSearch: openSearch),
              ),
              if (overview.isInitialLoading)
                const SliverToBoxAdapter(child: _HomeSkeleton())
              else ...[
                if (overview.showsCachedData)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppDimensions.gutter,
                        AppDimensions.xl,
                        AppDimensions.gutter,
                        0,
                      ),
                      child: OfflineBanner(cachedAt: overview.cachedAt),
                    ),
                  ),
                const SliverToBoxAdapter(child: _GenreFilters()),
                if (overview.showsCachedData) ...const [
                  // Hors ligne : sections « EN CACHE » (design page 12).
                  _HomeSection(MovieCategory.trending),
                  _HomeSection(MovieCategory.popular),
                  _HomeSection(MovieCategory.nowPlaying),
                ] else ...const [
                  _FeaturedMovie(),
                  _HomeSection(MovieCategory.popular),
                  _HomeSection(MovieCategory.nowPlaying),
                  _HomeSection(MovieCategory.trending, skipFirst: true),
                ],
              ],
              const SliverToBoxAdapter(
                child: SizedBox(height: AppDimensions.xxl),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _openMovie(BuildContext context, Movie movie) =>
    context.push(RoutePaths.movie(movie.id), extra: movie);

class _GenreFilters extends ConsumerWidget {
  const _GenreFilters();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final genres = ref.watch(genresProvider).value?.data;
    if (genres == null || genres.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: AppDimensions.xl),
      child: GenreFilterBar(
        genres: genres,
        selectedId: ref.watch(selectedGenreProvider),
        onSelected: ref.read(selectedGenreProvider.notifier).select,
      ),
    );
  }
}

/// Carte « N°1 DES TENDANCES ».
class _FeaturedMovie extends ConsumerWidget {
  const _FeaturedMovie();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trending = ref.watch(homeSectionProvider(MovieCategory.trending));
    final genreNames = ref.watch(genreNamesProvider);

    final Widget child = switch (trending) {
      AsyncValue(:final value?) when value.data.isNotEmpty => () {
        final movie = value.data.first;
        return FeaturedMovieCard(
          movie: movie,
          genreName: movie.genreIds
              .map((id) => genreNames[id])
              .nonNulls
              .firstOrNull,
          onTap: () => _openMovie(context, movie),
        );
      }(),
      AsyncValue(isLoading: true) => const Padding(
        padding: AppDimensions.screenPadding,
        child: SkeletonBox(height: 210, radius: AppDimensions.radiusLg + 4),
      ),
      _ => const SizedBox.shrink(),
    };

    return SliverPadding(
      padding: const EdgeInsets.only(top: AppDimensions.xl),
      sliver: SliverToBoxAdapter(child: child),
    );
  }
}

class _HomeSection extends ConsumerWidget {
  const _HomeSection(this.category, {this.skipFirst = false});

  final MovieCategory category;

  /// Tendances : le n°1 est déjà mis en avant par la carte principale.
  final bool skipFirst;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final section = ref.watch(homeSectionProvider(category));
    final hasGenreFilter = ref.watch(selectedGenreProvider) != null;
    final fromCache = section.value?.fromCache ?? false;

    final Widget content = switch (section) {
      AsyncValue(:final value?) => () {
        final movies = skipFirst ? value.data.skip(1).toList() : value.data;
        if (movies.isEmpty) {
          return CarouselMessage(
            hasGenreFilter
                ? 'Aucun film de ce genre dans cette sélection.'
                : 'Aucun film pour le moment.',
          );
        }
        return MovieCarousel(
          movies: movies,
          onMovieTap: (movie) => _openMovie(context, movie),
        );
      }(),
      AsyncValue(:final failure?) => CarouselMessage(
        failure.message,
        isError: true,
      ),
      _ => const MovieCarouselSkeleton(),
    };

    return SliverPadding(
      padding: const EdgeInsets.only(top: AppDimensions.xxl),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader(
              title: category.label,
              tag: fromCache ? 'EN CACHE' : null,
              actionLabel: 'Tout voir',
              onAction: () => context.push(RoutePaths.movieList(category.key)),
            ),
            const SizedBox(height: AppDimensions.md),
            content,
          ],
        ),
      ),
    );
  }
}

class _HomeSkeleton extends StatelessWidget {
  const _HomeSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: AppDimensions.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: AppDimensions.screenPadding,
            child: Row(
              children: [
                SkeletonBox(width: 76, height: 44, radius: 22),
                SizedBox(width: AppDimensions.sm),
                SkeletonBox(width: 96, height: 44, radius: 22),
                SizedBox(width: AppDimensions.sm),
                SkeletonBox(width: 96, height: 44, radius: 22),
              ],
            ),
          ),
          SizedBox(height: AppDimensions.xl),
          Padding(
            padding: AppDimensions.screenPadding,
            child: SkeletonBox(height: 210, radius: AppDimensions.radiusLg + 4),
          ),
          SizedBox(height: AppDimensions.xxl),
          Padding(
            padding: AppDimensions.screenPadding,
            child: SkeletonBox(width: 160, height: 28, radius: 6),
          ),
          SizedBox(height: AppDimensions.md),
          MovieCarouselSkeleton(),
        ],
      ),
    );
  }
}

/// « Impossible de charger les données. » (design page 13).
class _HomeError extends ConsumerWidget {
  const _HomeError({required this.greeting, required this.failure});

  final String greeting;
  final Failure failure;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final message = failure is CacheFailure
        ? 'Aucune donnée hors ligne n’est disponible. '
              'Vérifiez votre connexion puis réessayez.'
        : failure.message;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HomeHeader(greeting: greeting),
            Expanded(
              child: StateMessageView(
                tone: StateTone.error,
                icon: Icons.movie_filter_outlined,
                title: 'Impossible de charger les données.',
                message: message,
                primaryLabel: 'Réessayer',
                onPrimary: () => refreshHome(ref),
                secondaryLabel: 'Voir mes favoris',
                onSecondary: () => context.go(RoutePaths.favorites),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
