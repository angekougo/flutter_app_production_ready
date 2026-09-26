import 'dart:ui';

/// Langue et région des contenus TMDB (titres, synopsis, sorties en salle),
/// alignées sur la langue de l'application.
class TmdbLocale {
  const TmdbLocale({required this.language, required this.region});

  factory TmdbLocale.fromLocale(Locale locale) =>
      locale.languageCode == 'fr' ? french : english;

  static const french = TmdbLocale(language: 'fr-FR', region: 'FR');
  static const english = TmdbLocale(language: 'en-US', region: 'US');

  /// Paramètre `language` (ex. « fr-FR »).
  final String language;

  /// Paramètre `region` des listes « Populaires » et « Nouveautés ».
  final String region;
}
