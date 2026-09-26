import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../shared/models/fetched.dart';
import '../../../movies/domain/entities/movie.dart';
import '../../../movies/domain/entities/movie_category.dart';
import '../../../movies/domain/entities/paginated_movies.dart';
import '../../../movies/presentation/providers/movie_providers.dart';

/// Genre sélectionné dans les filtres de l'accueil (`null` = « Tous »).
class SelectedGenre extends Notifier<int?> {
  @override
  int? build() => null;

  void select(int? genreId) => state = genreId;
}

final selectedGenreProvider = NotifierProvider<SelectedGenre, int?>(
  SelectedGenre.new,
);

FutureProvider<Fetched<PaginatedMovies>> _sourceFor(MovieCategory category) =>
    switch (category) {
      MovieCategory.popular => popularMoviesProvider,
      MovieCategory.trending => trendingMoviesProvider,
      MovieCategory.nowPlaying => nowPlayingMoviesProvider,
    };

/// Films d'une section de l'accueil, filtrés par le genre sélectionné.
/// Le filtrage est local : il fonctionne aussi hors ligne.
final homeSectionProvider =
    Provider.family<AsyncValue<Fetched<List<Movie>>>, MovieCategory>((
      ref,
      category,
    ) {
      final genreId = ref.watch(selectedGenreProvider);
      return ref
          .watch(_sourceFor(category))
          .whenData(
            (fetched) => Fetched(
              genreId == null
                  ? fetched.data.movies
                  : fetched.data.movies
                        .where((m) => m.genreIds.contains(genreId))
                        .toList(),
              fromCache: fetched.fromCache,
              cachedAt: fetched.cachedAt,
            ),
          );
    });

/// Vue d'ensemble de l'accueil, dérivée des trois sections.
class HomeOverview {
  const HomeOverview({
    required this.isInitialLoading,
    required this.showsCachedData,
    this.cachedAt,
    this.blockingFailure,
  });

  /// Aucune section n'a encore de données.
  final bool isInitialLoading;

  /// Au moins une section provient du cache → bannière hors ligne.
  final bool showsCachedData;

  /// Date la plus ancienne parmi les sections en cache.
  final DateTime? cachedAt;

  /// Toutes les sections ont échoué sans aucune donnée à afficher.
  final Failure? blockingFailure;
}

final homeOverviewProvider = Provider<HomeOverview>((ref) {
  final sections = [
    for (final category in MovieCategory.values)
      ref.watch(_sourceFor(category)),
  ];

  final withData = sections.where((s) => s.hasValue).toList();
  final cached = withData.where((s) => s.value!.fromCache).toList();
  final cachedDates = cached.map((s) => s.value!.cachedAt).nonNulls.toList()
    ..sort();

  final allFailed =
      withData.isEmpty && sections.every((s) => s.hasError && !s.isLoading);
  final firstError = sections.map((s) => s.error).whereType<Failure>();

  return HomeOverview(
    isInitialLoading: withData.isEmpty && !allFailed,
    showsCachedData: cached.isNotEmpty,
    cachedAt: cachedDates.isEmpty ? null : cachedDates.first,
    blockingFailure: allFailed
        ? (firstError.isEmpty ? const UnknownFailure() : firstError.first)
        : null,
  );
});

/// Recharge toutes les données de l'accueil.
Future<void> refreshHome(WidgetRef ref) async {
  ref
    ..invalidate(popularMoviesProvider)
    ..invalidate(trendingMoviesProvider)
    ..invalidate(nowPlayingMoviesProvider)
    ..invalidate(genresProvider);
  // Attend la fin du rechargement (pour l'indicateur « tirer pour
  // rafraîchir »), sans propager les erreurs déjà affichées par l'UI.
  await Future.wait([
    for (final p in [
      popularMoviesProvider,
      trendingMoviesProvider,
      nowPlayingMoviesProvider,
    ])
      ref.read(p.future).then<void>((_) {}, onError: (Object _) {}),
  ]);
}
