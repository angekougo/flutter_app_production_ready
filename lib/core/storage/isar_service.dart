import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

/// Ouverture de la base Isar locale.
///
/// Les schémas sont fournis par l'appelant (voir `app/bootstrap.dart`) : le
/// `core` ne dépend ainsi d'aucune feature.
abstract final class IsarService {
  static const _name = 'cinetheque';

  static Future<Isar> open(List<CollectionSchema<dynamic>> schemas) async {
    final existing = Isar.getInstance(_name);
    if (existing != null) return existing;

    final dir = await getApplicationDocumentsDirectory();
    return Isar.open(
      schemas,
      directory: dir.path,
      name: _name,
      // Compacte la base au démarrage si plus de la moitié est inutilisée.
      compactOnLaunch: const CompactCondition(minRatio: 2),
    );
  }
}

/// Instance Isar ouverte au démarrage et injectée via `overrideWithValue`.
final isarProvider = Provider<Isar>(
  (ref) => throw UnimplementedError(
    'isarProvider doit être surchargé après IsarService.open().',
  ),
);
