import '../../../domain/entities/movie_details.dart';
import '../../local/models/cached_movie.dart';
import '../../local/models/cached_movie_details.dart';
import '../../local/movie_local_data_source.dart';
import 'movie_model.dart';

/// Réponse de `/movie/{id}?append_to_response=credits,similar`.
class MovieDetailsModel {
  const MovieDetailsModel({
    required this.movie,
    this.runtime,
    this.tagline,
    this.genres = const [],
    this.cast = const [],
    this.similar = const [],
  });

  /// Nombre d'acteurs conservés (générique principal) : suffisant pour
  /// l'écran et garde le cache léger.
  static const maxCast = 20;

  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) {
    final genres = [
      for (final g in (json['genres'] as List<dynamic>?) ?? const [])
        g as Map<String, dynamic>,
    ];
    final credits = json['credits'] as Map<String, dynamic>?;
    final castJson =
        [
          for (final c in (credits?['cast'] as List<dynamic>?) ?? const [])
            c as Map<String, dynamic>,
        ]..sort(
          (a, b) => ((a['order'] as num?) ?? 999).compareTo(
            (b['order'] as num?) ?? 999,
          ),
        );
    final similar = json['similar'] as Map<String, dynamic>?;

    return MovieDetailsModel(
      // La fiche détaillée donne `genres` (objets) et non `genre_ids`.
      movie: MovieModel.fromJson({
        ...json,
        'genre_ids': [for (final g in genres) g['id']],
      }),
      runtime: (json['runtime'] as num?)?.toInt(),
      tagline: _nonEmpty(json['tagline'] as String?),
      genres: [for (final g in genres) g['name'] as String],
      cast: [
        for (final c in castJson.take(maxCast))
          CastMember(
            id: c['id'] as int,
            name: c['name'] as String? ?? '',
            character: _nonEmpty(c['character'] as String?),
            profilePath: c['profile_path'] as String?,
          ),
      ],
      similar: [
        for (final m in (similar?['results'] as List<dynamic>?) ?? const [])
          MovieModel.fromJson(m as Map<String, dynamic>),
      ],
    );
  }

  factory MovieDetailsModel.fromCached(CachedMovieFull cached) =>
      MovieDetailsModel(
        movie: MovieModel.fromCached(cached.movie),
        runtime: cached.details.runtime,
        tagline: cached.details.tagline,
        genres: cached.details.genreNames,
        cast: [
          for (final c in cached.details.cast)
            CastMember(
              id: c.id,
              name: c.name,
              character: c.character,
              profilePath: c.profilePath,
            ),
        ],
        similar: [for (final m in cached.similar) MovieModel.fromCached(m)],
      );

  final MovieModel movie;
  final int? runtime;
  final String? tagline;
  final List<String> genres;
  final List<CastMember> cast;
  final List<MovieModel> similar;

  MovieDetails toEntity() => MovieDetails(
    movie: movie.toEntity(),
    runtime: (runtime ?? 0) > 0 ? runtime : null,
    tagline: tagline,
    genres: genres,
    cast: cast,
    similar: [for (final m in similar) m.toEntity()],
  );

  CachedMovie toCachedMovie() => movie.toCached();

  CachedMovieDetails toCachedDetails() => CachedMovieDetails()
    ..runtime = runtime
    ..tagline = tagline
    ..genreNames = genres
    ..cast = [
      for (final (i, c) in cast.indexed)
        CachedCastMember(
          id: c.id,
          name: c.name,
          character: c.character,
          profilePath: c.profilePath,
          order: i,
        ),
    ]
    ..cachedAt = DateTime.now();

  List<CachedMovie> toCachedSimilar() => [
    for (final m in similar) m.toCached(),
  ];

  static String? _nonEmpty(String? value) =>
      (value == null || value.trim().isEmpty) ? null : value;
}
