import 'package:isar_community/isar.dart';

part 'cached_actor.g.dart';

/// Fiche acteur + filmographie.
@collection
class CachedActor {
  CachedActor();

  /// Id TMDB.
  late Id id;

  late String name;
  String? biography;

  /// Format TMDB « AAAA-MM-JJ ».
  String? birthday;
  String? deathday;
  String? placeOfBirth;
  String? profilePath;
  String? knownForDepartment;

  /// 1 = femme, 2 = homme, 0/3 = non renseigné (convention TMDB).
  int gender = 0;

  List<CachedActorCredit> credits = [];

  late DateTime cachedAt;
}

@embedded
class CachedActorCredit {
  CachedActorCredit({
    this.movieId = 0,
    this.title = '',
    this.character,
    this.releaseDate,
    this.posterPath,
    this.voteAverage = 0,
    this.popularity = 0,
  });

  int movieId;
  String title;
  String? character;
  String? releaseDate;
  String? posterPath;
  double voteAverage;
  double popularity;
}
