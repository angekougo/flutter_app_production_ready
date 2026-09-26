import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../../../shared/extensions/async_value_x.dart';
import '../../../../shared/extensions/l10n_x.dart';
import '../../../../shared/widgets/app_snack_bar.dart';
import '../../../../shared/widgets/offline_banner.dart';
import '../../../../shared/widgets/person_avatar.dart';
import '../../../../shared/widgets/round_icon_button.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../../../shared/widgets/state_message_view.dart';
import '../../../favorites/presentation/providers/favorites_providers.dart';
import '../../../home/presentation/widgets/movie_carousel.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_details.dart';
import '../providers/movie_providers.dart';
import '../widgets/movie_details_sections.dart';

/// Fiche d'un film. [preview] (le film tel qu'affiché dans la liste
/// d'origine) permet d'afficher l'en-tête immédiatement pendant le
/// chargement de la fiche complète.
class MovieDetailsPage extends ConsumerWidget {
  const MovieDetailsPage({super.key, required this.movieId, this.preview});

  final int movieId;
  final Movie? preview;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(movieDetailsProvider(movieId));
    final isFavorite = ref.watch(isFavoriteProvider(movieId)).value ?? false;

    // Le favori peut être ajouté dès l'aperçu, avant la fiche complète.
    final movie = details.value?.data.movie ?? preview;
    final VoidCallback? toggleFavorite = movie == null
        ? null
        : () => _toggleFavorite(
            context,
            ref,
            movie,
            genres: details.value?.data.genres ?? const [],
            isFavorite: isFavorite,
          );

    final Widget body = switch (details) {
      AsyncValue(:final value?) => _DetailsContent(
        details: value.data,
        fromCache: value.fromCache,
        cachedAt: value.cachedAt,
        isFavorite: isFavorite,
        onToggleFavorite: toggleFavorite!,
      ),
      AsyncValue(:final failure?) => _DetailsError(
        failure: failure,
        preview: preview,
        onRetry: () => ref.invalidate(movieDetailsProvider(movieId)),
      ),
      _ => _DetailsLoading(preview: preview),
    };

    return Scaffold(
      body: Stack(
        children: [
          body,
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.md,
                vertical: AppDimensions.sm,
              ),
              child: Row(
                children: [
                  RoundIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    tooltip: context.l10n.back,
                    onPressed: () => context.canPop()
                        ? context.pop()
                        : context.go(RoutePaths.home),
                  ),
                  const Spacer(),
                  RoundIconButton(
                    icon: isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: isFavorite ? AppColors.projecteur : AppColors.papier,
                    tooltip: isFavorite
                        ? context.l10n.favoriteRemove
                        : context.l10n.favoriteAdd,
                    onPressed: toggleFavorite,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _toggleFavorite(
  BuildContext context,
  WidgetRef ref,
  Movie movie, {
  required List<String> genres,
  required bool isFavorite,
}) async {
  final messenger = ScaffoldMessenger.of(context);
  final l10n = context.l10n;
  final result = await ref
      .read(favoriteActionsProvider)
      .toggle(movie, isFavorite: isFavorite, genres: genres);
  switch (result) {
    case Success(data: true):
      showAppSnackBar(messenger, l10n.favoriteAdded, tone: SnackTone.success);
    case Success():
      showAppSnackBar(messenger, l10n.favoriteRemoved);
    case Error(:final failure):
      showAppSnackBar(
        messenger,
        l10n.failureMessage(failure),
        tone: SnackTone.error,
      );
  }
}

void _openMovie(BuildContext context, Movie movie) =>
    context.push(RoutePaths.movie(movie.id), extra: movie);

class _DetailsContent extends StatelessWidget {
  const _DetailsContent({
    required this.details,
    required this.fromCache,
    required this.isFavorite,
    required this.onToggleFavorite,
    this.cachedAt,
  });

  final MovieDetails details;
  final bool fromCache;
  final DateTime? cachedAt;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  static const _visibleCast = 8;

  @override
  Widget build(BuildContext context) {
    final movie = details.movie;
    final l10n = context.l10n;
    const gap = SizedBox(height: AppDimensions.xl);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: MovieDetailsHeader(movie: movie)),
        const SliverToBoxAdapter(child: gap),
        if (fromCache)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.gutter,
                0,
                AppDimensions.gutter,
                AppDimensions.xl,
              ),
              child: OfflineBanner(cachedAt: cachedAt),
            ),
          ),
        SliverToBoxAdapter(
          child: MovieStatsBar(movie: movie, runtime: details.runtime),
        ),
        if (details.genres.isNotEmpty) ...[
          const SliverToBoxAdapter(child: gap),
          SliverToBoxAdapter(child: GenrePills(genres: details.genres)),
        ],
        const SliverToBoxAdapter(child: gap),
        SliverToBoxAdapter(
          child: Padding(
            padding: AppDimensions.screenPadding,
            child: isFavorite
                ? OutlinedButton.icon(
                    onPressed: onToggleFavorite,
                    icon: const Icon(
                      Icons.favorite_rounded,
                      color: AppColors.projecteur,
                    ),
                    label: Text(l10n.favoriteRemove),
                  )
                : FilledButton.icon(
                    onPressed: onToggleFavorite,
                    icon: const Icon(Icons.favorite_border_rounded),
                    label: Text(l10n.favoriteAdd),
                  ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppDimensions.xxl)),
        SliverToBoxAdapter(
          child: Padding(
            padding: AppDimensions.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.synopsis,
                  style: AppTypography.section.copyWith(fontSize: 26),
                ),
                const SizedBox(height: AppDimensions.md),
                Text(
                  movie.overview ?? l10n.synopsisUnavailable,
                  style: AppTypography.body.copyWith(
                    fontSize: 16,
                    color: AppColors.papier.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (details.cast.isNotEmpty) ...[
          const SliverToBoxAdapter(child: SizedBox(height: AppDimensions.xxl)),
          SliverToBoxAdapter(
            child: SectionHeader(
              title: l10n.cast,
              actionLabel: details.cast.length > _visibleCast
                  ? l10n.seeAll
                  : null,
              onAction: () => _showFullCast(context, details.cast),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppDimensions.lg)),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 150,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: AppDimensions.screenPadding,
                itemCount: details.cast.length.clamp(0, _visibleCast),
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppDimensions.md),
                itemBuilder: (context, index) {
                  final member = details.cast[index];
                  return CastMemberTile(
                    member: member,
                    onTap: () => _openActor(context, member),
                  );
                },
              ),
            ),
          ),
        ],
        if (details.similar.isNotEmpty) ...[
          const SliverToBoxAdapter(child: SizedBox(height: AppDimensions.xxl)),
          SliverToBoxAdapter(child: SectionHeader(title: l10n.similarMovies)),
          const SliverToBoxAdapter(child: SizedBox(height: AppDimensions.lg)),
          SliverToBoxAdapter(
            child: MovieCarousel(
              movies: details.similar,
              showRatings: false,
              onMovieTap: (m) => _openMovie(context, m),
            ),
          ),
        ],
        const SliverToBoxAdapter(child: SizedBox(height: 48)),
      ],
    );
  }
}

void _openActor(BuildContext context, CastMember member) =>
    context.push(RoutePaths.actor(member.id), extra: member);

Future<void> _showFullCast(BuildContext context, List<CastMember> cast) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.salle,
    showDragHandle: true,
    builder: (sheetContext) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      builder: (context, controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.only(bottom: AppDimensions.xl),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.gutter,
              0,
              AppDimensions.gutter,
              AppDimensions.md,
            ),
            child: Text(context.l10n.cast, style: AppTypography.section),
          ),
          for (final member in cast)
            ListTile(
              contentPadding: AppDimensions.screenPadding,
              leading: PersonAvatar(
                personId: member.id,
                initials: member.initials,
                profilePath: member.profilePath,
                size: 48,
              ),
              title: Text(member.name, style: AppTypography.bodyStrong),
              subtitle: member.character == null
                  ? null
                  : Text(member.character!, style: AppTypography.caption),
              trailing: const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.poussiere,
              ),
              onTap: () {
                Navigator.of(sheetContext).pop();
                _openActor(context, member);
              },
            ),
        ],
      ),
    ),
  );
}

class _DetailsLoading extends StatelessWidget {
  const _DetailsLoading({this.preview});

  final Movie? preview;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        if (preview != null)
          MovieDetailsHeader(movie: preview!)
        else
          const SkeletonBox(
            height: MovieDetailsHeader.backdropHeight,
            radius: 0,
          ),
        const SizedBox(height: AppDimensions.xl),
        const Padding(
          padding: AppDimensions.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonBox(height: 56, radius: 8),
              SizedBox(height: AppDimensions.xl),
              SkeletonBox(width: 220, height: 40, radius: 20),
              SizedBox(height: AppDimensions.xl),
              SkeletonBox(height: 52, radius: AppDimensions.radiusLg),
              SizedBox(height: AppDimensions.xxl),
              SkeletonBox(width: 140, height: 26, radius: 6),
              SizedBox(height: AppDimensions.md),
              SkeletonBox(height: 90, radius: 8),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailsError extends StatelessWidget {
  const _DetailsError({
    required this.failure,
    required this.onRetry,
    this.preview,
  });

  final Failure failure;
  final Movie? preview;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (IconData icon, String title, String message) = switch (failure) {
      NotFoundFailure() => (
        Icons.movie_filter_outlined,
        l10n.failureMovieNotFound,
        l10n.movieNotFoundMessage,
      ),
      CacheFailure() => (
        Icons.wifi_off_rounded,
        l10n.detailsOfflineTitle,
        l10n.detailsOfflineMessage,
      ),
      _ => (
        Icons.movie_filter_outlined,
        l10n.loadErrorTitle,
        l10n.failureMessage(failure),
      ),
    };

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 64),
        child: StateMessageView(
          tone: failure is CacheFailure ? StateTone.neutral : StateTone.error,
          icon: icon,
          title: preview?.title ?? title,
          message: preview == null ? message : '$title $message',
          primaryLabel: failure is NotFoundFailure ? null : l10n.retry,
          onPrimary: onRetry,
        ),
      ),
    );
  }
}
