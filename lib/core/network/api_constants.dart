abstract final class ApiConstants {
  // TMDB
  static const tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static const tmdbImageBaseUrl = 'https://image.tmdb.org/t/p';

  static const popularMovies = '/movie/popular';
  static const trendingMovies = '/trending/movie/week';
  static const nowPlayingMovies = '/movie/now_playing';
  static const genres = '/genre/movie/list';
  static const searchMovies = '/search/movie';
  static String movieDetails(int id) => '/movie/$id';
  static String movieCredits(int id) => '/movie/$id/credits';
  static String similarMovies(int id) => '/movie/$id/similar';
  static String person(int id) => '/person/$id';
  static String personMovieCredits(int id) => '/person/$id/movie_credits';

  // Supabase Auth REST
  static const supabaseUser = '/auth/v1/user';

  static const connectTimeout = Duration(seconds: 10);
  static const receiveTimeout = Duration(seconds: 15);

  static String? poster(String? path, {String size = 'w342'}) =>
      path == null ? null : '$tmdbImageBaseUrl/$size$path';

  static String? backdrop(String? path, {String size = 'w780'}) =>
      path == null ? null : '$tmdbImageBaseUrl/$size$path';

  static String? profile(String? path, {String size = 'w185'}) =>
      path == null ? null : '$tmdbImageBaseUrl/$size$path';
}
