import 'package:isar_community/isar.dart';

part 'cached_movie_details.g.dart';

/// Informations de la fiche film qui ne figurent pas dans le résumé
/// [CachedMovie] : durée, genres, casting, films similaires.
@collection
class CachedMovieDetails {
  CachedMovieDetails();

  /// Id TMDB (identique à celui du [CachedMovie] associé).
  late Id id;

  /// Durée en minutes.
  int? runtime;
  String? tagline;
  List<String> genreNames = [];
  List<CachedCastMember> cast = [];

  /// Ids des films similaires (stockés dans [CachedMovie]).
  List<int> similarIds = [];

  late DateTime cachedAt;
}

@embedded
class CachedCastMember {
  CachedCastMember({
    this.id = 0,
    this.name = '',
    this.character,
    this.profilePath,
    this.order = 0,
  });

  int id;
  String name;
  String? character;
  String? profilePath;
  int order;
}
