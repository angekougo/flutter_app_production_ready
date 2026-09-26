import '../../../../core/result/result.dart';
import '../entities/favorite.dart';

/// Favoris de l'utilisateur connecté, stockés localement (disponibles hors
/// ligne). Les flux émettent un `Failure` en cas d'erreur.
abstract interface class FavoritesRepository {
  /// Du plus récent au plus ancien ; réémet à chaque ajout/suppression.
  Stream<List<Favorite>> watchFavorites();

  Stream<bool> watchIsFavorite(int movieId);

  Future<Result<void>> addFavorite(Favorite favorite);

  Future<Result<void>> removeFavorite(int movieId);

  Future<Result<int>> countFavorites();
}
