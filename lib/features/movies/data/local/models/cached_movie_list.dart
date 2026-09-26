import 'package:isar_community/isar.dart';

import '../../../../../core/storage/fast_hash.dart';

part 'cached_movie_list.g.dart';

/// Une page d'une liste TMDB : populaires, tendances, nouveautés.
///
/// Ne stocke que les ids, dans l'ordre TMDB ; les films sont dans
/// [CachedMovie].
@collection
class CachedMovieList {
  CachedMovieList();

  static String keyFor(String category, int page) => '$category:$page';

  Id get isarId => fastHash(key);

  /// « popular:1 », « trending:1 », « now_playing:1 »…
  @Index(unique: true, replace: true)
  late String key;

  late String category;
  late int page;
  int totalPages = 1;
  List<int> movieIds = [];

  late DateTime cachedAt;
}
