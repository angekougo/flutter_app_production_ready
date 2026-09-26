import 'dart:async';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/favorite.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../local/favorites_local_data_source.dart';
import '../local/models/favorite_movie.dart';

/// Lit l'id de l'utilisateur connecté (`null` sans session).
typedef CurrentUserIdReader = String? Function();

class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl({required this._local, required this._currentUserId});

  final FavoritesLocalDataSource _local;
  final CurrentUserIdReader _currentUserId;

  static const _noSession = UnauthorizedFailure(UnauthorizedReason.notSignedIn);

  @override
  Stream<List<Favorite>> watchFavorites() {
    final ownerId = _currentUserId();
    if (ownerId == null) return Stream.error(_noSession);
    return _local
        .watchFavorites(ownerId)
        .map((list) => [for (final f in list) f.toEntity()])
        .transform(_toFailures());
  }

  @override
  Stream<bool> watchIsFavorite(int movieId) {
    final ownerId = _currentUserId();
    if (ownerId == null) return Stream.value(false);
    return _local.watchIsFavorite(ownerId, movieId).transform(_toFailures());
  }

  @override
  Future<Result<void>> addFavorite(Favorite favorite) => _run(
    (ownerId) =>
        _local.addFavorite(FavoriteMovieX.fromEntity(favorite, ownerId)),
  );

  @override
  Future<Result<void>> removeFavorite(int movieId) =>
      _run((ownerId) => _local.removeFavorite(ownerId, movieId));

  @override
  Future<Result<int>> countFavorites() => _run(_local.countFavorites);

  Future<Result<T>> _run<T>(Future<T> Function(String ownerId) body) async {
    final ownerId = _currentUserId();
    if (ownerId == null) return const Error(_noSession);
    try {
      return Success(await body(ownerId));
    } on AppException catch (e) {
      return Error(mapExceptionToFailure(e));
    }
  }

  /// Les erreurs Isar du flux deviennent des `Failure` pour l'UI.
  static StreamTransformer<T, T> _toFailures<T>() =>
      StreamTransformer.fromHandlers(
        handleError: (error, stackTrace, sink) => sink.addError(
          error is AppException
              ? mapExceptionToFailure(error)
              : const CacheFailure(),
          stackTrace,
        ),
      );
}

extension FavoriteMovieX on FavoriteMovie {
  static FavoriteMovie fromEntity(Favorite favorite, String ownerId) =>
      FavoriteMovie()
        ..ownerId = ownerId
        ..movieId = favorite.movieId
        ..title = favorite.title
        ..originalTitle = favorite.originalTitle
        ..posterPath = favorite.posterPath
        ..backdropPath = favorite.backdropPath
        ..releaseDate = favorite.releaseDate?.toIso8601String().substring(0, 10)
        ..voteAverage = favorite.voteAverage
        ..genreNames = favorite.genres
        ..addedAt = favorite.addedAt;

  Favorite toEntity() => Favorite(
    movieId: movieId,
    title: title,
    originalTitle: originalTitle,
    posterPath: posterPath,
    backdropPath: backdropPath,
    releaseDate: releaseDate == null ? null : DateTime.tryParse(releaseDate!),
    voteAverage: voteAverage,
    genres: genreNames,
    addedAt: addedAt,
  );
}
