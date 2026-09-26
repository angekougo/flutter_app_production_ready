import '../../../domain/entities/movie.dart';
import '../../local/models/cached_movie.dart';

/// DTO d'un film TMDB (`results[]` des listes).
///
/// Centralise les conversions JSON → entité, JSON → cache et cache → entité.
class MovieModel {
  const MovieModel({
    required this.id,
    required this.title,
    this.originalTitle,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    this.voteAverage = 0,
    this.voteCount = 0,
    this.popularity = 0,
    this.genreIds = const [],
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
    id: json['id'] as int,
    title: (json['title'] as String?) ?? (json['name'] as String?) ?? '',
    originalTitle: json['original_title'] as String?,
    overview: _nonEmpty(json['overview'] as String?),
    posterPath: json['poster_path'] as String?,
    backdropPath: json['backdrop_path'] as String?,
    releaseDate: _nonEmpty(json['release_date'] as String?),
    voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0,
    voteCount: (json['vote_count'] as num?)?.toInt() ?? 0,
    popularity: (json['popularity'] as num?)?.toDouble() ?? 0,
    genreIds: [
      for (final id in (json['genre_ids'] as List<dynamic>?) ?? const [])
        id as int,
    ],
  );

  factory MovieModel.fromCached(CachedMovie cached) => MovieModel(
    id: cached.id,
    title: cached.title,
    originalTitle: cached.originalTitle,
    overview: cached.overview,
    posterPath: cached.posterPath,
    backdropPath: cached.backdropPath,
    releaseDate: cached.releaseDate,
    voteAverage: cached.voteAverage,
    voteCount: cached.voteCount,
    popularity: cached.popularity,
    genreIds: cached.genreIds,
  );

  final int id;
  final String title;
  final String? originalTitle;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;

  /// « AAAA-MM-JJ », conservé tel quel pour le cache.
  final String? releaseDate;
  final double voteAverage;
  final int voteCount;
  final double popularity;
  final List<int> genreIds;

  Movie toEntity() => Movie(
    id: id,
    title: title,
    originalTitle: originalTitle,
    overview: overview,
    posterPath: posterPath,
    backdropPath: backdropPath,
    releaseDate: releaseDate == null ? null : DateTime.tryParse(releaseDate!),
    voteAverage: voteAverage,
    voteCount: voteCount,
    popularity: popularity,
    genreIds: genreIds,
  );

  CachedMovie toCached({DateTime? cachedAt}) => CachedMovie()
    ..id = id
    ..title = title
    ..originalTitle = originalTitle
    ..overview = overview
    ..posterPath = posterPath
    ..backdropPath = backdropPath
    ..releaseDate = releaseDate
    ..voteAverage = voteAverage
    ..voteCount = voteCount
    ..popularity = popularity
    ..genreIds = genreIds
    ..cachedAt = cachedAt ?? DateTime.now();

  static String? _nonEmpty(String? value) =>
      (value == null || value.trim().isEmpty) ? null : value;
}
