import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../../../shared/models/fetched.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/movie_usecases.dart';
import 'movie_providers.dart';

enum SearchStatus { idle, loading, success, failure }

class SearchState extends Equatable {
  const SearchState({
    this.query = '',
    this.status = SearchStatus.idle,
    this.movies = const [],
    this.page = 0,
    this.totalPages = 0,
    this.totalResults = 0,
    this.fromCache = false,
    this.cachedAt,
    this.failure,
    this.isLoadingMore = false,
    this.loadMoreFailure,
  });

  final String query;
  final SearchStatus status;
  final List<Movie> movies;
  final int page;
  final int totalPages;
  final int totalResults;
  final bool fromCache;
  final DateTime? cachedAt;
  final Failure? failure;
  final bool isLoadingMore;
  final Failure? loadMoreFailure;

  bool get hasMore => page < totalPages;

  SearchState copyWith({
    List<Movie>? movies,
    int? page,
    int? totalPages,
    bool? fromCache,
    bool? isLoadingMore,
    Failure? loadMoreFailure,
    bool clearLoadMoreFailure = false,
  }) => SearchState(
    query: query,
    status: status,
    movies: movies ?? this.movies,
    page: page ?? this.page,
    totalPages: totalPages ?? this.totalPages,
    totalResults: totalResults,
    fromCache: fromCache ?? this.fromCache,
    cachedAt: cachedAt,
    failure: failure,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    loadMoreFailure: clearLoadMoreFailure
        ? null
        : (loadMoreFailure ?? this.loadMoreFailure),
  );

  @override
  List<Object?> get props => [
    query,
    status,
    movies,
    page,
    totalPages,
    totalResults,
    fromCache,
    cachedAt,
    failure,
    isLoadingMore,
    loadMoreFailure,
  ];
}

/// Recherche de films : anti-rebond, pagination et protection contre les
/// réponses arrivées dans le désordre.
class MovieSearchController extends Notifier<SearchState> {
  Timer? _debounce;

  /// Incrémenté à chaque nouvelle recherche : une réponse dont l'id ne
  /// correspond plus est ignorée (l'utilisateur a tapé autre chose entre-temps).
  int _requestId = 0;

  @override
  SearchState build() {
    ref.onDispose(() => _debounce?.cancel());
    return const SearchState();
  }

  /// Appelé à chaque frappe : la recherche part après une courte pause.
  void onQueryChanged(String query) {
    _debounce?.cancel();
    if (!SearchMovies.isValidQuery(query)) {
      _requestId++; // annule toute recherche en vol
      state = SearchState(query: query);
      return;
    }
    _debounce = Timer(AppConstants.searchDebounce, () => _search(query));
  }

  /// Validation clavier ou recherche récente : immédiate.
  Future<void> submit(String query) async {
    _debounce?.cancel();
    if (!SearchMovies.isValidQuery(query)) return onQueryChanged(query);
    await _search(query);
  }

  Future<void> retry() => _search(state.query);

  Future<void> _search(String query) async {
    final requestId = ++_requestId;
    state = SearchState(query: query, status: SearchStatus.loading);

    final result = await ref.read(searchMoviesProvider)(query);
    if (!ref.mounted || requestId != _requestId) return;

    state = switch (result) {
      Success(:final data, :final fromCache, :final cachedAt) => SearchState(
        query: query,
        status: SearchStatus.success,
        movies: data.movies,
        page: data.page,
        totalPages: data.totalPages,
        totalResults: data.totalResults,
        fromCache: fromCache,
        cachedAt: cachedAt,
      ),
      Error(:final failure) => SearchState(
        query: query,
        status: SearchStatus.failure,
        failure: failure,
      ),
    };

    if (result case Success(:final data) when data.movies.isNotEmpty) {
      ref.invalidate(recentSearchesProvider);
    }
  }

  Future<void> loadMore() async {
    final current = state;
    if (current.status != SearchStatus.success ||
        current.isLoadingMore ||
        !current.hasMore) {
      return;
    }
    final requestId = _requestId;
    state = current.copyWith(isLoadingMore: true, clearLoadMoreFailure: true);

    final result = await ref.read(searchMoviesProvider)(
      current.query,
      page: current.page + 1,
    );
    if (!ref.mounted || requestId != _requestId) return;

    state = switch (result) {
      Success(:final data, :final fromCache) => current.copyWith(
        movies: [
          ...current.movies,
          ...data.movies.where(
            (m) => !current.movies.any((existing) => existing.id == m.id),
          ),
        ],
        page: data.page,
        totalPages: data.totalPages,
        fromCache: current.fromCache || fromCache,
        isLoadingMore: false,
      ),
      Error(:final failure) => current.copyWith(
        isLoadingMore: false,
        loadMoreFailure: failure,
      ),
    };
  }
}

/// Conservé entre les changements d'onglet : on retrouve sa recherche.
final movieSearchProvider =
    NotifierProvider<MovieSearchController, SearchState>(
      MovieSearchController.new,
    );

/// Recherches récentes (depuis le cache Isar, disponibles hors ligne).
final recentSearchesProvider = FutureProvider<List<String>>(
  (ref) async => (await ref.watch(getRecentSearchesProvider)().orThrow()).data,
);
