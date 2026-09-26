/// Listes de films proposées sur l'accueil.
enum MovieCategory {
  popular('popular', 'Populaires'),
  trending('trending', 'Tendances'),
  nowPlaying('now_playing', 'Nouveautés');

  const MovieCategory(this.key, this.label);

  /// Identifiant stable (clé de cache, paramètre de route).
  final String key;
  final String label;

  static MovieCategory? fromKey(String key) {
    for (final category in values) {
      if (category.key == key) return category;
    }
    return null;
  }
}
