abstract final class AppConstants {
  static const appName = 'Cinéthèque';

  /// Au-delà de cette durée, une donnée en cache est considérée comme ancienne.
  static const cacheMaxAge = Duration(hours: 6);

  static const searchDebounce = Duration(milliseconds: 400);
}
