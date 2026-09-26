import '../../../../core/result/result.dart';
import '../entities/profile_entities.dart';

abstract interface class ProfileRepository {
  /// Compte lu sur Supabase (requête authentifiée par le JWT). Hors ligne,
  /// renvoie le compte de la session locale (`fromCache: true`). Une session
  /// expirée et non renouvelable donne `UnauthorizedFailure`.
  Future<Result<UserProfile>> getProfile();

  SessionInfo getSessionInfo();

  Future<Result<OfflineStats>> getOfflineStats();
}
