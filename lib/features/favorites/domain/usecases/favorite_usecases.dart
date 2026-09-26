import '../../../../core/result/result.dart';
import '../../../movies/domain/entities/movie.dart';
import '../entities/favorite.dart';
import '../repositories/favorites_repository.dart';

class WatchFavorites {
  const WatchFavorites(this._repository);
  final FavoritesRepository _repository;

  Stream<List<Favorite>> call() => _repository.watchFavorites();
}

class WatchIsFavorite {
  const WatchIsFavorite(this._repository);
  final FavoritesRepository _repository;

  Stream<bool> call(int movieId) => _repository.watchIsFavorite(movieId);
}

class AddFavorite {
  const AddFavorite(this._repository);
  final FavoritesRepository _repository;

  Future<Result<void>> call(Favorite favorite) =>
      _repository.addFavorite(favorite);
}

class RemoveFavorite {
  const RemoveFavorite(this._repository);
  final FavoritesRepository _repository;

  Future<Result<void>> call(int movieId) => _repository.removeFavorite(movieId);
}

/// Ajoute le film s'il n'est pas en favori, le retire sinon.
/// Renvoie le nouvel état (`true` = désormais en favori).
class ToggleFavorite {
  const ToggleFavorite(this._repository);
  final FavoritesRepository _repository;

  Future<Result<bool>> call(
    Movie movie, {
    required bool isFavorite,
    List<String> genres = const [],
  }) async {
    final result = isFavorite
        ? await _repository.removeFavorite(movie.id)
        : await _repository.addFavorite(
            Favorite.fromMovie(movie, genres: genres),
          );
    return switch (result) {
      Success() => Success(!isFavorite),
      Error(:final failure) => Error(failure),
    };
  }
}
