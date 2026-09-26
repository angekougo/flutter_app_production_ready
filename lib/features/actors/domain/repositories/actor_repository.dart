import '../../../../core/result/result.dart';
import '../entities/actor_details.dart';

abstract interface class ActorRepository {
  /// Fiche acteur + filmographie ; disponible hors ligne une fois consultée.
  Future<Result<ActorDetails>> getActorDetails(int actorId);
}
