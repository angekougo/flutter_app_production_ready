import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_category.dart';
import 'movie_providers.dart';

/// État d'une liste paginée (défilement infini).
class PagedMovies extends Equatable {
  const PagedMovies({
    required this.movies,
    required this.page,
    required this.totalPages,
    this.fromCache = false,
    this.cachedAt,
    this.isLoadingMore = false,
    this.loadMoreFailure,
  });

  final List<Movie> movies;
  final int page;
  final int totalPages;
  final bool fromCache;
  final DateTime? cachedAt;
  final bool isLoadingMore;

  /// Échec du chargement de la page suivante (la liste reste affichée).
  final Failure? loadMoreFailure;

  bool get hasMore => page < totalPages;

  PagedMovies copyWith({
    List<Movie>? movies,
    int? page,
    int? totalPages,
    bool? fromCache,
    DateTime? cachedAt,
    bool? isLoadingMore,
    Failure? loadMoreFailure,
    bool clearFailure = false,
  }) => PagedMovies(
    movies: movies ?? this.movies,
    page: page ?? this.page,
    totalPages: totalPages ?? this.totalPages,
    fromCache: fromCache ?? this.fromCache,
    cachedAt: cachedAt ?? this.cachedAt,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    loadMoreFailure: clearFailure
        ? null
        : (loadMoreFailure ?? this.loadMoreFailure),
  );

  @override
  List<Object?> get props => [
    movies,
    page,
    totalPages,
    fromCache,
    cachedAt,
    isLoadingMore,
    loadMoreFailure,
  ];
}

class MovieListController extends AsyncNotifier<PagedMovies> {
  MovieListController(this.category);

  final MovieCategory category;

  @override
  Future<PagedMovies> build() async {
    final result = await ref.read(getMoviesByCategoryProvider)(category);
    return switch (result) {
      Success(:final data, :final fromCache, :final cachedAt) => PagedMovies(
        movies: data.movies,
        page: data.page,
        totalPages: data.totalPages,
        fromCache: fromCache,
        cachedAt: cachedAt,
      ),
      Error(:final failure) => throw failure,
    };
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || current.isLoadingMore || !current.hasMore) return;

    state = AsyncData(
      current.copyWith(isLoadingMore: true, clearFailure: true),
    );
    final result = await ref.read(getMoviesByCategoryProvider)(
      category,
      page: current.page + 1,
    );
    if (!ref.mounted) return;

    state = AsyncData(switch (result) {
      Success(:final data, :final fromCache) => current.copyWith(
        // TMDB peut renvoyer un film déjà vu quand le classement bouge
        // entre deux pages : on dédoublonne.
        movies: _merge(current.movies, data.movies),
        page: data.page,
        totalPages: data.totalPages,
        fromCache: current.fromCache || fromCache,
        isLoadingMore: false,
      ),
      Error(:final failure) => current.copyWith(
        isLoadingMore: false,
        loadMoreFailure: failure,
      ),
    });
  }

  static List<Movie> _merge(List<Movie> current, List<Movie> next) {
    final seen = {for (final m in current) m.id};
    return [...current, ...next.where((m) => seen.add(m.id))];
  }
}

final movieListControllerProvider = AsyncNotifierProvider.autoDispose
    .family<MovieListController, PagedMovies, MovieCategory>(
      MovieListController.new,
    );
