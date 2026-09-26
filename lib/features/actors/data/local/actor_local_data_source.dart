import 'package:isar_community/isar.dart';

import '../../../../core/error/exceptions.dart';
import 'models/cached_actor.dart';

abstract interface class ActorLocalDataSource {
  Future<void> cacheActor(CachedActor actor);

  /// `null` si l'acteur n'a jamais été consulté.
  Future<CachedActor?> getActor(int actorId);
}

class IsarActorLocalDataSource implements ActorLocalDataSource {
  IsarActorLocalDataSource(this._isar);

  final Isar _isar;

  @override
  Future<void> cacheActor(CachedActor actor) =>
      _guard(() => _isar.writeTxn(() => _isar.cachedActors.put(actor)));

  @override
  Future<CachedActor?> getActor(int actorId) =>
      _guard(() => _isar.cachedActors.get(actorId));

  Future<T> _guard<T>(Future<T> Function() body) async {
    try {
      return await body();
    } on IsarError catch (e) {
      throw CacheException(e.message);
    }
  }
}
