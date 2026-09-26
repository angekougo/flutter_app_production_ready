abstract final class AppConstants {
  static const appName = 'Cinéthèque';

  /// Langue des contenus TMDB (titres, synopsis…).
  static const tmdbLanguage = 'fr-FR';
  static const tmdbRegion = 'FR';

  /// Au-delà de cette durée, une donnée en cache est considérée comme ancienne.
  static const cacheMaxAge = Duration(hours: 6);

  static const searchDebounce = Duration(milliseconds: 400);
}
