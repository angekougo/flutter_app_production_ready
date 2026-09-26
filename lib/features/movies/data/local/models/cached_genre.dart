import 'package:isar_community/isar.dart';

part 'cached_genre.g.dart';

/// Genre TMDB (« Drame », « Thriller »…), pour les filtres de l'accueil et
/// l'affichage des genres hors ligne.
@collection
class CachedGenre {
  CachedGenre();

  /// Id TMDB.
  late Id id;
  late String name;
  late DateTime cachedAt;
}
