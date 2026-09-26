import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/result/result.dart';
import '../../../favorites/data/local/favorites_local_data_source.dart';
import '../../../movies/data/local/movie_local_data_source.dart';
import '../../domain/entities/profile_entities.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_data_sources.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({
    required this._remote,
    required this._session,
    required this._movies,
    required this._favorites,
    required this._networkInfo,
  });

  final ProfileRemoteDataSource _remote;
  final SessionDataSource _session;
  final MovieLocalDataSource _movies;
  final FavoritesLocalDataSource _favorites;
  final NetworkInfo _networkInfo;

  @override
  Future<Result<UserProfile>> getProfile() async {
    if (await _networkInfo.isConnected) {
      try {
        return Success(await _remote.getUser());
      } on UnauthorizedException {
        // Pas de repli sur la session locale : elle n'est plus valide.
        return const Error(UnauthorizedFailure());
      } on AppException {
        // Réseau capricieux ou erreur serveur : repli sur la session.
      }
    }
    final local = _session.currentUser;
    if (local == null) return const Error(UnauthorizedFailure());
    return Success(local, fromCache: true, cachedAt: DateTime.now());
  }

  @override
  SessionInfo getSessionInfo() => _session.sessionInfo;

  @override
  Future<Result<OfflineStats>> getOfflineStats() async {
    try {
      final ownerId = _session.currentUser?.id;
      return Success(
        OfflineStats(
          cachedMovies: await _movies.countCachedMovies(),
          favorites: ownerId == null
              ? 0
              : await _favorites.countFavorites(ownerId),
          lastUpdate: await _movies.lastUpdate(),
        ),
      );
    } on AppException catch (e) {
      return Error(mapExceptionToFailure(e));
    }
  }
}
