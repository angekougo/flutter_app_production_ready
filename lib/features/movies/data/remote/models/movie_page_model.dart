import '../../../domain/entities/paginated_movies.dart';
import 'movie_model.dart';

/// Réponse paginée TMDB : `{ page, results, total_pages, total_results }`.
class MoviePageModel {
  const MoviePageModel({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  /// TMDB annonce parfois plus de pages qu'il n'en sert réellement : toute
  /// page au-delà de 500 renvoie une erreur 400.
  static const maxTmdbPages = 500;

  factory MoviePageModel.fromJson(Map<String, dynamic> json) {
    final totalPages = (json['total_pages'] as num?)?.toInt() ?? 1;
    return MoviePageModel(
      page: (json['page'] as num?)?.toInt() ?? 1,
      results: [
        for (final item in (json['results'] as List<dynamic>?) ?? const [])
          MovieModel.fromJson(item as Map<String, dynamic>),
      ],
      totalPages: totalPages.clamp(1, maxTmdbPages),
      totalResults: (json['total_results'] as num?)?.toInt() ?? 0,
    );
  }

  final int page;
  final List<MovieModel> results;
  final int totalPages;
  final int totalResults;

  PaginatedMovies toEntity() => PaginatedMovies(
    movies: [for (final m in results) m.toEntity()],
    page: page,
    totalPages: totalPages,
    totalResults: totalResults,
  );
}
