import '../../../../core/result/result.dart';
import '../entities/profile_entities.dart';
import '../repositories/profile_repository.dart';

class GetProfile {
  const GetProfile(this._repository);
  final ProfileRepository _repository;

  Future<Result<UserProfile>> call() => _repository.getProfile();
}

class GetSessionInfo {
  const GetSessionInfo(this._repository);
  final ProfileRepository _repository;

  SessionInfo call() => _repository.getSessionInfo();
}

class GetOfflineStats {
  const GetOfflineStats(this._repository);
  final ProfileRepository _repository;

  Future<Result<OfflineStats>> call() => _repository.getOfflineStats();
}
