import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/result/result.dart';
import '../../../../core/storage/isar_service.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../movies/domain/entities/movie.dart';
import '../../data/local/favorites_local_data_source.dart';
import '../../data/repositories/favorites_repository_impl.dart';
import '../../domain/entities/favorite.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../domain/usecases/favorite_usecases.dart';

// ─── Injection de dépendances ────────────────────────────────────────────────

final favoritesLocalDataSourceProvider = Provider<FavoritesLocalDataSource>(
  (ref) => IsarFavoritesLocalDataSource(ref.watch(isarProvider)),
);

final favoritesRepositoryProvider = Provider<FavoritesRepository>(
  (ref) => FavoritesRepositoryImpl(
    local: ref.watch(favoritesLocalDataSourceProvider),
    currentUserId: () => ref.read(getCurrentUserProvider)()?.id,
  ),
);

final watchFavoritesProvider = Provider(
  (ref) => WatchFavorites(ref.watch(favoritesRepositoryProvider)),
);
final watchIsFavoriteProvider = Provider(
  (ref) => WatchIsFavorite(ref.watch(favoritesRepositoryProvider)),
);
final addFavoriteProvider = Provider(
  (ref) => AddFavorite(ref.watch(favoritesRepositoryProvider)),
);
final removeFavoriteProvider = Provider(
  (ref) => RemoveFavorite(ref.watch(favoritesRepositoryProvider)),
);
final toggleFavoriteProvider = Provider(
  (ref) => ToggleFavorite(ref.watch(favoritesRepositoryProvider)),
);

// ─── État ────────────────────────────────────────────────────────────────────

/// Favoris de l'utilisateur connecté (flux réactif Isar). Relancé quand
/// l'utilisateur change : chaque compte a ses favoris.
final favoritesProvider = StreamProvider<List<Favorite>>((ref) {
  ref.watch(currentUserProvider);
  return ref.watch(watchFavoritesProvider)();
});

final isFavoriteProvider = StreamProvider.autoDispose.family<bool, int>((
  ref,
  movieId,
) {
  ref.watch(currentUserProvider);
  return ref.watch(watchIsFavoriteProvider)(movieId);
});

/// Actions déclenchées par l'UI (le résultat sert à notifier l'utilisateur).
class FavoriteActions {
  const FavoriteActions(this._ref);
  final Ref _ref;

  Future<Result<bool>> toggle(
    Movie movie, {
    required bool isFavorite,
    List<String> genres = const [],
  }) => _ref.read(toggleFavoriteProvider)(
    movie,
    isFavorite: isFavorite,
    genres: genres,
  );

  Future<Result<void>> remove(Favorite favorite) =>
      _ref.read(removeFavoriteProvider)(favorite.movieId);

  /// « Annuler » après une suppression : restaure le favori à l'identique.
  Future<Result<void>> restore(Favorite favorite) =>
      _ref.read(addFavoriteProvider)(favorite);
}

final favoriteActionsProvider = Provider(FavoriteActions.new);
