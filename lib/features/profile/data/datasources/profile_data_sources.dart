import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_error_mapper.dart';
import '../../domain/entities/profile_entities.dart';

/// Compte utilisateur via l'API REST Supabase Auth, avec Dio.
///
/// Le JWT n'est pas ajouté ici : c'est le rôle de `AuthInterceptor`
/// (injection + rafraîchissement sur 401).
abstract interface class ProfileRemoteDataSource {
  Future<UserProfile> getUser();
}

class SupabaseProfileRemoteDataSource implements ProfileRemoteDataSource {
  SupabaseProfileRemoteDataSource(this._dio);

  final Dio _dio;

  @override
  Future<UserProfile> getUser() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiConstants.supabaseUser,
      );
      return userProfileFromJson(response.data ?? const {});
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}

/// `GET /auth/v1/user` → [UserProfile].
UserProfile userProfileFromJson(Map<String, dynamic> json) {
  final metadata = json['user_metadata'] as Map<String, dynamic>?;
  final appMetadata = json['app_metadata'] as Map<String, dynamic>?;
  return UserProfile(
    id: json['id'] as String? ?? '',
    email: json['email'] as String? ?? '',
    fullName: metadata?['full_name'] as String?,
    createdAt: DateTime.tryParse(json['created_at'] as String? ?? ''),
    lastSignInAt: DateTime.tryParse(json['last_sign_in_at'] as String? ?? ''),
    provider: appMetadata?['provider'] as String?,
  );
}

/// Session locale Supabase : disponible sans réseau.
abstract interface class SessionDataSource {
  UserProfile? get currentUser;
  SessionInfo get sessionInfo;
}

class SupabaseSessionDataSource implements SessionDataSource {
  SupabaseSessionDataSource(this._auth);

  final sb.GoTrueClient _auth;

  @override
  UserProfile? get currentUser {
    final user = _auth.currentUser;
    return user == null ? null : userProfileFromJson(user.toJson());
  }

  @override
  SessionInfo get sessionInfo {
    final session = _auth.currentSession;
    final expiresAt = session?.expiresAt;
    return SessionInfo(
      hasSession: session != null,
      expiresAt: expiresAt == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(expiresAt * 1000),
    );
  }
}
