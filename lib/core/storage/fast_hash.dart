/// Hash FNV-1a 64 bits, optimisé pour les chaînes Dart (recommandé par la
/// documentation Isar) : transforme une clé texte (« popular:1 ») en `Id`.
int fastHash(String value) {
  var hash = 0xcbf29ce484222325;

  var i = 0;
  while (i < value.length) {
    final codeUnit = value.codeUnitAt(i++);
    hash ^= codeUnit >> 8;
    hash *= 0x100000001b3;
    hash ^= codeUnit & 0xFF;
    hash *= 0x100000001b3;
  }

  return hash;
}
