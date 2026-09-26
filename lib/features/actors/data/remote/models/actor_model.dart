import '../../../domain/entities/actor_details.dart';
import '../../local/models/cached_actor.dart';

/// Réponse de `/person/{id}?append_to_response=movie_credits`.
class ActorModel {
  const ActorModel({
    required this.id,
    required this.name,
    this.biography,
    this.birthday,
    this.deathday,
    this.placeOfBirth,
    this.profilePath,
    this.knownForDepartment,
    this.gender = 0,
    this.credits = const [],
  });

  factory ActorModel.fromJson(Map<String, dynamic> json) {
    final movieCredits = json['movie_credits'] as Map<String, dynamic>?;
    List<Map<String, dynamic>> list(String key) => [
      for (final c in (movieCredits?[key] as List<dynamic>?) ?? const [])
        c as Map<String, dynamic>,
    ];

    return ActorModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      biography: _nonEmpty(json['biography'] as String?),
      birthday: _nonEmpty(json['birthday'] as String?),
      deathday: _nonEmpty(json['deathday'] as String?),
      placeOfBirth: _nonEmpty(json['place_of_birth'] as String?),
      profilePath: json['profile_path'] as String?,
      knownForDepartment: json['known_for_department'] as String?,
      gender: (json['gender'] as num?)?.toInt() ?? 0,
      credits: _mergeCredits(cast: list('cast'), crew: list('crew')),
    );
  }

  factory ActorModel.fromCached(CachedActor cached) => ActorModel(
    id: cached.id,
    name: cached.name,
    biography: cached.biography,
    birthday: cached.birthday,
    deathday: cached.deathday,
    placeOfBirth: cached.placeOfBirth,
    profilePath: cached.profilePath,
    knownForDepartment: cached.knownForDepartment,
    gender: cached.gender,
    credits: cached.credits,
  );

  final int id;
  final String name;
  final String? biography;
  final String? birthday;
  final String? deathday;
  final String? placeOfBirth;
  final String? profilePath;
  final String? knownForDepartment;
  final int gender;
  final List<CachedActorCredit> credits;

  ActorModel withBiography(String? value) => ActorModel(
    id: id,
    name: name,
    biography: _nonEmpty(value),
    birthday: birthday,
    deathday: deathday,
    placeOfBirth: placeOfBirth,
    profilePath: profilePath,
    knownForDepartment: knownForDepartment,
    gender: gender,
    credits: credits,
  );

  ActorDetails toEntity() => ActorDetails(
    id: id,
    name: name,
    biography: biography,
    birthday: _date(birthday),
    deathday: _date(deathday),
    placeOfBirth: placeOfBirth,
    profilePath: profilePath,
    knownForDepartment: knownForDepartment,
    gender: switch (gender) {
      1 => ActorGender.female,
      2 => ActorGender.male,
      _ => ActorGender.unknown,
    },
    credits: [
      for (final c in credits)
        ActorCredit(
          movieId: c.movieId,
          title: c.title,
          role: c.character,
          releaseDate: _date(c.releaseDate),
          posterPath: c.posterPath,
          voteAverage: c.voteAverage,
        ),
    ],
  );

  CachedActor toCached() => CachedActor()
    ..id = id
    ..name = name
    ..biography = biography
    ..birthday = birthday
    ..deathday = deathday
    ..placeOfBirth = placeOfBirth
    ..profilePath = profilePath
    ..knownForDepartment = knownForDepartment
    ..gender = gender
    ..credits = credits
    ..cachedAt = DateTime.now();

  /// Un film n'apparaît qu'une fois (rôle d'acteur prioritaire sur un poste
  /// technique), du plus récent au plus ancien ; films sans date à la fin.
  static List<CachedActorCredit> _mergeCredits({
    required List<Map<String, dynamic>> cast,
    required List<Map<String, dynamic>> crew,
  }) {
    final byMovie = <int, CachedActorCredit>{};
    void add(Map<String, dynamic> json, String? role) {
      final id = json['id'] as int;
      byMovie.putIfAbsent(
        id,
        () => CachedActorCredit(
          movieId: id,
          title: json['title'] as String? ?? '',
          character: _nonEmpty(role),
          releaseDate: _nonEmpty(json['release_date'] as String?),
          posterPath: json['poster_path'] as String?,
          voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0,
          popularity: (json['popularity'] as num?)?.toDouble() ?? 0,
        ),
      );
    }

    for (final c in cast) {
      add(c, c['character'] as String?);
    }
    for (final c in crew) {
      // Les remerciements au générique ne sont pas une participation.
      if (c['job'] == 'Thanks') continue;
      add(c, _jobLabel(c['job'] as String?));
    }

    return byMovie.values.toList()..sort((a, b) {
      final da = a.releaseDate, db = b.releaseDate;
      if (da == null && db == null) return b.popularity.compareTo(a.popularity);
      if (da == null) return 1;
      if (db == null) return -1;
      return db.compareTo(da); // « AAAA-MM-JJ » se trie comme du texte
    });
  }

  static String? _jobLabel(String? job) => switch (job) {
    'Director' => 'Réalisation',
    'Screenplay' || 'Writer' => 'Scénario',
    'Producer' => 'Production',
    'Executive Producer' => 'Production exécutive',
    'Original Music Composer' => 'Musique',
    'Director of Photography' => 'Image',
    'Editor' => 'Montage',
    _ => job,
  };

  static DateTime? _date(String? value) =>
      value == null ? null : DateTime.tryParse(value);

  static String? _nonEmpty(String? value) =>
      (value == null || value.trim().isEmpty) ? null : value.trim();
}
