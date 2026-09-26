import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/error/failures.dart';
import '../../../../shared/extensions/l10n_x.dart';
import '../../../../shared/widgets/offline_banner.dart';
import '../../../../shared/widgets/state_message_view.dart';
import '../../domain/usecases/movie_usecases.dart';
import '../providers/movie_providers.dart';
import '../providers/movie_search_controller.dart';
import '../widgets/search_result_tile.dart';

/// Recherche de films.
///
/// L'écran lui-même ne se reconstruit jamais pendant la frappe : l'état de
/// recherche est observé par [_SearchBody], et le texte saisi par les seuls
/// widgets qui l'affichent ([_SearchField], [_IdleView]).
class SearchPage extends HookConsumerWidget {
  const SearchPage({super.key});

  static const _loadMoreThreshold = 500.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Reprend la dernière requête : la recherche survit au changement d'onglet.
    final text = useTextEditingController(
      text: ref.read(movieSearchProvider).query,
    );
    MovieSearchController controller() =>
        ref.read(movieSearchProvider.notifier);

    void useRecent(String query) {
      text
        ..text = query
        ..selection = TextSelection.collapsed(offset: query.length);
      FocusScope.of(context).unfocus();
      controller().submit(query);
    }

    void clear() {
      text.clear();
      controller().onQueryChanged('');
    }

    bool onScroll(ScrollNotification notification) {
      if (notification.metrics.extentAfter < _loadMoreThreshold) {
        controller().loadMore();
      }
      return false;
    }

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    header: true,
                    child: Text(
                      context.l10n.searchTitle,
                      style: AppTypography.screenTitle,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.lg),
                  Text(
                    context.l10n.searchFieldLabel,
                    style: AppTypography.overline,
                  ),
                  const SizedBox(height: AppDimensions.sm),
                  _SearchField(
                    controller: text,
                    onChanged: (value) => controller().onQueryChanged(value),
                    onSubmitted: (value) => controller().submit(value),
                    onClear: clear,
                  ),
                ],
              ),
            ),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: onScroll,
                child: _SearchBody(text: text, onRecentTap: useRecent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchField extends HookWidget {
  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    // Seul ce champ se reconstruit à la frappe (bouton « Effacer »).
    final isEmpty = useValueListenable(controller).text.isEmpty;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusLg + 4),
      borderSide: const BorderSide(color: AppColors.trait),
    );
    return TextField(
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textInputAction: TextInputAction.search,
      autocorrect: false,
      cursorColor: AppColors.projecteur,
      style: AppTypography.bodyStrong.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: context.l10n.searchHint,
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: AppDimensions.lg, right: 6),
          child: Icon(Icons.search_rounded, color: AppColors.poussiere),
        ),
        suffixIcon: isEmpty
            ? null
            : IconButton(
                tooltip: context.l10n.searchClear,
                onPressed: onClear,
                icon: const Icon(Icons.close_rounded, color: AppColors.papier),
              ),
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: const BorderSide(color: AppColors.projecteur, width: 1.5),
        ),
      ),
    );
  }
}

class _SearchBody extends ConsumerWidget {
  const _SearchBody({required this.text, required this.onRecentTap});

  final TextEditingController text;
  final ValueChanged<String> onRecentTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(movieSearchProvider);
    final notifier = ref.read(movieSearchProvider.notifier);
    final l10n = context.l10n;

    switch (state.status) {
      case SearchStatus.idle:
        return _IdleView(text: text, onRecentTap: onRecentTap);
      case SearchStatus.loading:
        return Semantics(
          label: l10n.a11yLoading,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: AppDimensions.lg),
            itemCount: 6,
            itemBuilder: (_, _) => const SearchResultSkeleton(),
          ),
        );

      case SearchStatus.failure:
        final failure = state.failure ?? const UnknownFailure();
        if (failure is CacheFailure) {
          return StateMessageView(
            icon: Icons.wifi_off_rounded,
            title: l10n.searchOfflineTitle,
            message: l10n.searchOfflineMessage,
            primaryLabel: l10n.retry,
            onPrimary: notifier.retry,
            secondaryLabel: l10n.seeMyFavorites,
            onSecondary: () => context.go(RoutePaths.favorites),
          );
        }
        return StateMessageView(
          tone: StateTone.error,
          icon: Icons.movie_filter_outlined,
          title: l10n.searchFailedTitle,
          message: l10n.failureMessage(failure),
          primaryLabel: l10n.retry,
          onPrimary: notifier.retry,
        );

      case SearchStatus.success when state.movies.isEmpty:
        return StateMessageView(
          icon: Icons.search_off_rounded,
          title: l10n.searchNoResultsTitle,
          message: l10n.searchNoResultsMessage(state.query.trim()),
        );

      case SearchStatus.success:
        return _Results(state: state, onRetry: notifier.loadMore);
    }
  }
}

class _IdleView extends HookConsumerWidget {
  const _IdleView({required this.text, required this.onRecentTap});

  final TextEditingController text;
  final ValueChanged<String> onRecentTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typedQuery = useValueListenable(text).text;
    if (typedQuery.trim().isNotEmpty) {
      // Requête trop courte, ou saisie en cours (anti-rebond).
      return Padding(
        padding: const EdgeInsets.all(AppDimensions.gutter),
        child: Text(
          SearchMovies.isValidQuery(typedQuery)
              ? ''
              : context.l10n.searchMinLength(SearchMovies.minQueryLength),
          style: AppTypography.body,
        ),
      );
    }

    final recent = ref.watch(recentSearchesProvider).value ?? const [];
    if (recent.isEmpty) {
      return StateMessageView(
        icon: Icons.search_rounded,
        title: context.l10n.searchIdleTitle,
        message: context.l10n.searchIdleMessage,
      );
    }

    return ListView(
      padding: const EdgeInsets.all(AppDimensions.gutter),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: [
        const SizedBox(height: AppDimensions.sm),
        Text(context.l10n.searchRecent, style: AppTypography.overline),
        const SizedBox(height: AppDimensions.md),
        Wrap(
          spacing: AppDimensions.sm,
          runSpacing: AppDimensions.sm,
          children: [
            for (final query in recent)
              ActionChip(
                avatar: const Icon(
                  Icons.history_rounded,
                  size: 18,
                  color: AppColors.poussiere,
                ),
                label: Text(query),
                onPressed: () => onRecentTap(query),
              ),
          ],
        ),
      ],
    );
  }
}

class _Results extends ConsumerWidget {
  const _Results({required this.state, required this.onRetry});

  final SearchState state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final genreNames = ref.watch(genreNamesProvider);
    final count = state.totalResults;

    return CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        if (state.fromCache)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.gutter,
              AppDimensions.lg,
              AppDimensions.gutter,
              0,
            ),
            sliver: SliverToBoxAdapter(
              child: OfflineBanner(cachedAt: state.cachedAt),
            ),
          ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.gutter,
            AppDimensions.xl,
            AppDimensions.gutter,
            AppDimensions.sm,
          ),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    context.l10n.searchResultCount(count),
                    style: AppTypography.bodyStrong.copyWith(fontSize: 17),
                  ),
                ),
                Text(
                  context.l10n.searchPage(state.page, state.totalPages),
                  style: AppTypography.overline,
                ),
              ],
            ),
          ),
        ),
        SliverList.separated(
          itemCount: state.movies.length,
          separatorBuilder: (_, _) => const Divider(
            indent: AppDimensions.gutter,
            endIndent: AppDimensions.gutter,
          ),
          itemBuilder: (context, index) {
            final movie = state.movies[index];
            return SearchResultTile(
              movie: movie,
              genreName: movie.genreIds
                  .map((id) => genreNames[id])
                  .nonNulls
                  .firstOrNull,
              onTap: () =>
                  context.push(RoutePaths.movie(movie.id), extra: movie),
            );
          },
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

  final SearchState state;
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
    } else {
      child = const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.xl),
      child: Center(child: child),
    );
  }
}
