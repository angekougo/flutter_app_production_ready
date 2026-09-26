import 'package:isar_community/isar.dart';

import '../../../../../core/storage/fast_hash.dart';

part 'cached_search.g.dart';

/// Une page de résultats pour une recherche donnée.
@collection
class CachedSearch {
  CachedSearch();

  /// La requête est normalisée (minuscules, espaces réduits) pour que
  /// « Nuit » et « nuit » partagent le même cache.
  static String normalize(String query) =>
      query.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

  static String keyFor(String query, int page) => '${normalize(query)}:$page';

  Id get isarId => fastHash(key);

  @Index(unique: true, replace: true)
  late String key;

  @Index()
  late String query;

  late int page;
  int totalPages = 1;
  int totalResults = 0;
  List<int> movieIds = [];

  late DateTime cachedAt;
}
