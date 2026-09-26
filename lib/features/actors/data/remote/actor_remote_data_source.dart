import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_error_mapper.dart';
import 'models/actor_model.dart';

abstract interface class ActorRemoteDataSource {
  Future<ActorModel> getActor(int actorId);
}

class TmdbActorRemoteDataSource implements ActorRemoteDataSource {
  TmdbActorRemoteDataSource(this._dio);

  final Dio _dio;

  @override
  Future<ActorModel> getActor(int actorId) async {
    final actor = ActorModel.fromJson(
      await _get(ApiConstants.person(actorId), {
        'append_to_response': 'movie_credits',
      }),
    );
    if (actor.biography != null) return actor;

    // Beaucoup de biographies n'existent qu'en anglais : on tente ce repli,
    // sans faire échouer la fiche s'il ne répond pas.
    try {
      final english = await _get(ApiConstants.person(actorId), {
        'language': 'en-US',
      });
      return actor.withBiography(english['biography'] as String?);
    } on AppException {
      return actor;
    }
  }

  Future<Map<String, dynamic>> _get(
    String path,
    Map<String, dynamic> query,
  ) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: query,
      );
      return response.data ?? const {};
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
