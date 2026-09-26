import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/repository/network_first.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/actor_details.dart';
import '../../domain/repositories/actor_repository.dart';
import '../local/actor_local_data_source.dart';
import '../remote/actor_remote_data_source.dart';
import '../remote/models/actor_model.dart';

class ActorRepositoryImpl implements ActorRepository {
  ActorRepositoryImpl({
    required this._remote,
    required this._local,
    required this._networkInfo,
  });

  final ActorRemoteDataSource _remote;
  final ActorLocalDataSource _local;
  final NetworkInfo _networkInfo;

  @override
  Future<Result<ActorDetails>> getActorDetails(int actorId) async {
    final result = await networkFirst(
      networkInfo: _networkInfo,
      fetchRemote: () async {
        final actor = await _remote.getActor(actorId);
        await saveQuietly(() => _local.cacheActor(actor.toCached()));
        return actor.toEntity();
      },
      readCache: () async {
        final cached = await _local.getActor(actorId);
        if (cached == null) return null;
        return (
          data: ActorModel.fromCached(cached).toEntity(),
          cachedAt: cached.cachedAt,
        );
      },
    );
    // Le message par défaut (« Film introuvable. ») ne convient pas ici.
    if (result case Error(failure: NotFoundFailure())) {
      return const Error(NotFoundFailure('Acteur introuvable.'));
    }
    return result;
  }
}
