import 'package:isar_community/isar.dart';

import '../../../../core/error/exceptions.dart';
import 'models/favorite_movie.dart';

/// Favoris stockés localement, par utilisateur ([ownerId] = id Supabase).
abstract interface class FavoritesLocalDataSource {
  /// Favoris de l'utilisateur, du plus récent au plus ancien ; réémet à
  /// chaque ajout/suppression.
  Stream<List<FavoriteMovie>> watchFavorites(String ownerId);

  Future<List<FavoriteMovie>> getFavorites(String ownerId);

  Stream<bool> watchIsFavorite(String ownerId, int movieId);

  Future<bool> isFavorite(String ownerId, int movieId);

  /// Ajoute (ou remplace) un favori.
  Future<void> addFavorite(FavoriteMovie favorite);

  Future<void> removeFavorite(String ownerId, int movieId);

  Future<int> countFavorites(String ownerId);
}

class IsarFavoritesLocalDataSource implements FavoritesLocalDataSource {
  IsarFavoritesLocalDataSource(this._isar);

  final Isar _isar;

  QueryBuilder<FavoriteMovie, FavoriteMovie, QAfterSortBy> _byOwner(
    String ownerId,
  ) => _isar.favoriteMovies
      .where()
      .ownerIdEqualToAnyMovieId(ownerId)
      .sortByAddedAtDesc();

  @override
  Stream<List<FavoriteMovie>> watchFavorites(String ownerId) =>
      _byOwner(ownerId).watch(fireImmediately: true);

  @override
  Future<List<FavoriteMovie>> getFavorites(String ownerId) =>
      _guard(() => _byOwner(ownerId).findAll());

  @override
  Stream<bool> watchIsFavorite(String ownerId, int movieId) => _isar
      .favoriteMovies
      .where()
      .ownerIdMovieIdEqualTo(ownerId, movieId)
      .watch(fireImmediately: true)
      .map((results) => results.isNotEmpty);

  @override
  Future<bool> isFavorite(String ownerId, int movieId) => _guard(
    () async =>
        await _isar.favoriteMovies.getByOwnerIdMovieId(ownerId, movieId) !=
        null,
  );

  @override
  Future<void> addFavorite(FavoriteMovie favorite) => _guard(
    () => _isar.writeTxn(
      () => _isar.favoriteMovies.putByOwnerIdMovieId(favorite),
    ),
  );

  @override
  Future<void> removeFavorite(String ownerId, int movieId) => _guard(
    () => _isar.writeTxn(
      () => _isar.favoriteMovies.deleteByOwnerIdMovieId(ownerId, movieId),
    ),
  );

  @override
  Future<int> countFavorites(String ownerId) => _guard(
    () =>
        _isar.favoriteMovies.where().ownerIdEqualToAnyMovieId(ownerId).count(),
  );

  Future<T> _guard<T>(Future<T> Function() body) async {
    try {
      return await body();
    } on IsarError catch (e) {
      throw CacheException(e.message);
    }
  }
}
