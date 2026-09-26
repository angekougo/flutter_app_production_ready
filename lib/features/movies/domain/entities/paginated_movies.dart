import 'package:equatable/equatable.dart';

import 'movie.dart';

/// Une page de résultats TMDB.
class PaginatedMovies extends Equatable {
  const PaginatedMovies({
    required this.movies,
    required this.page,
    required this.totalPages,
    required this.totalResults,
  });

  final List<Movie> movies;
  final int page;
  final int totalPages;
  final int totalResults;

  bool get hasMore => page < totalPages;

  @override
  List<Object?> get props => [movies, page, totalPages, totalResults];
}
