import 'package:isar_community/isar.dart';

part 'cached_movie.g.dart';

/// Résumé d'un film (tel que renvoyé par les listes TMDB).
///
/// Stocké une seule fois et référencé par id depuis les listes, les
/// recherches, les films similaires et les filmographies.
@collection
class CachedMovie {
  CachedMovie();

  /// Id TMDB.
  late Id id;

  late String title;
  String? originalTitle;
  String? overview;
  String? posterPath;
  String? backdropPath;

  /// Format TMDB « AAAA-MM-JJ ».
  String? releaseDate;

  double voteAverage = 0;
  int voteCount = 0;
  double popularity = 0;
  List<int> genreIds = [];

  @Index()
  late DateTime cachedAt;
}
