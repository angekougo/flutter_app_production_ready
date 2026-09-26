abstract final class RoutePaths {
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/login/register';

  static const home = '/home';
  static const search = '/search';
  static const favorites = '/favorites';
  static const profile = '/profile';

  static const movieDetails = '/movie/:id';
  static const actorDetails = '/actor/:id';

  /// Sous-route de l'accueil : garde la barre de navigation visible.
  static const movieListSegment = 'movies/:category';
  static String movieList(String categoryKey) => '$home/movies/$categoryKey';

  static String movie(int id) => '/movie/$id';
  static String actor(int id) => '/actor/$id';
}
