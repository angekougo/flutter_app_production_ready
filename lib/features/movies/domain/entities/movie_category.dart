/// Listes de films proposées sur l'accueil.
///
/// Le libellé affiché est traduit par la présentation (`l10n_x.dart`).
enum MovieCategory {
  popular('popular'),
  trending('trending'),
  nowPlaying('now_playing');

  const MovieCategory(this.key);

  /// Identifiant stable (clé de cache, paramètre de route).
  final String key;

  static MovieCategory? fromKey(String key) {
    for (final category in values) {
      if (category.key == key) return category;
    }
    return null;
  }
}
