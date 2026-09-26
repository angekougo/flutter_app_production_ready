import 'package:isar_community/isar.dart';

part 'favorite_movie.g.dart';

/// Film ajouté aux favoris par un utilisateur.
///
/// Autonome (ne dépend pas du cache [CachedMovie], qui peut être purgé) :
/// les favoris restent affichables hors ligne en toutes circonstances.
@collection
class FavoriteMovie {
  FavoriteMovie();

  Id id = Isar.autoIncrement;

  /// Id Supabase de l'utilisateur : chaque compte a ses propres favoris,
  /// même sur un appareil partagé.
  @Index(unique: true, replace: true, composite: [CompositeIndex('movieId')])
  late String ownerId;

  /// Id TMDB.
  late int movieId;

  late String title;
  String? originalTitle;
  String? posterPath;
  String? backdropPath;
  String? releaseDate;
  double voteAverage = 0;
  List<String> genreNames = [];

  @Index()
  late DateTime addedAt;
}
