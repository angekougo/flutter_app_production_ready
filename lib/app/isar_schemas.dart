import 'package:isar_community/isar.dart';

import '../features/actors/data/local/models/cached_actor.dart';
import '../features/favorites/data/local/models/favorite_movie.dart';
import '../features/movies/data/local/models/cached_genre.dart';
import '../features/movies/data/local/models/cached_movie.dart';
import '../features/movies/data/local/models/cached_movie_details.dart';
import '../features/movies/data/local/models/cached_movie_list.dart';
import '../features/movies/data/local/models/cached_search.dart';

/// Toutes les collections Isar de l'application. La couche `app` assemble
/// les features ; `core/storage/isar_service.dart` reste indépendant.
const isarSchemas = <CollectionSchema<dynamic>>[
  CachedMovieSchema,
  CachedMovieListSchema,
  CachedSearchSchema,
  CachedMovieDetailsSchema,
  CachedGenreSchema,
  CachedActorSchema,
  FavoriteMovieSchema,
];
