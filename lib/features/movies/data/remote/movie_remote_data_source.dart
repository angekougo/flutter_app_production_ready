import 'package:dio/dio.dart';

import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_error_mapper.dart';
import '../../domain/entities/movie_category.dart';
import 'models/genre_model.dart';
import 'models/movie_details_model.dart';
import 'models/movie_page_model.dart';

abstract interface class MovieRemoteDataSource {
  Future<MoviePageModel> getMovies(MovieCategory category, {required int page});

  Future<List<GenreModel>> getGenres();

  Future<MoviePageModel> searchMovies(String query, {required int page});

  /// Fiche, casting et films similaires en un seul appel.
  Future<MovieDetailsModel> getMovieDetails(int movieId);
}

/// Appels TMDB via Dio. L'authentification (Bearer) et la langue sont
/// ajoutées par `TmdbInterceptor` ; les erreurs Dio deviennent des
/// `AppException` typées.
class TmdbMovieRemoteDataSource implements MovieRemoteDataSource {
  TmdbMovieRemoteDataSource(this._dio, {required this.region});

  final Dio _dio;

  /// Région TMDB (ex. « FR ») des listes Populaires et Nouveautés.
  final String region;

  @override
  Future<MoviePageModel> getMovies(
    MovieCategory category, {
    required int page,
  }) async {
    final (path, params) = switch (category) {
      MovieCategory.popular => (ApiConstants.popularMovies, {'region': region}),
      MovieCategory.trending => (
        ApiConstants.trendingMovies,
        <String, String>{},
      ),
      MovieCategory.nowPlaying => (
        ApiConstants.nowPlayingMovies,
        {'region': region},
      ),
    };
    final json = await _get(path, {...params, 'page': page});
    return MoviePageModel.fromJson(json);
  }

  @override
  Future<List<GenreModel>> getGenres() async {
    final json = await _get(ApiConstants.genres);
    return [
      for (final item in (json['genres'] as List<dynamic>?) ?? const [])
        GenreModel.fromJson(item as Map<String, dynamic>),
    ];
  }

  @override
  Future<MoviePageModel> searchMovies(String query, {required int page}) async {
    final json = await _get(ApiConstants.searchMovies, {
      'query': query,
      'page': page,
      'include_adult': false,
    });
    return MoviePageModel.fromJson(json);
  }

  @override
  Future<MovieDetailsModel> getMovieDetails(int movieId) async {
    final json = await _get(ApiConstants.movieDetails(movieId), {
      'append_to_response': 'credits,similar',
    });
    return MovieDetailsModel.fromJson(json);
  }

  Future<Map<String, dynamic>> _get(
    String path, [
    Map<String, dynamic>? query,
  ]) async {
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
