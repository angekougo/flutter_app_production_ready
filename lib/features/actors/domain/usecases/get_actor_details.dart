import '../../../../core/result/result.dart';
import '../entities/actor_details.dart';
import '../repositories/actor_repository.dart';

class GetActorDetails {
  const GetActorDetails(this._repository);
  final ActorRepository _repository;

  Future<Result<ActorDetails>> call(int actorId) =>
      _repository.getActorDetails(actorId);
}
