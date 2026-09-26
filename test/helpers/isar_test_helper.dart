import 'dart:io';

import 'package:flutter_app_production_ready/app/isar_schemas.dart';
import 'package:isar_community/isar.dart';

/// Ouvre une base Isar temporaire (moteur natif téléchargé au premier
/// lancement). Chaque test obtient une base vierge.
Future<Isar> openTestIsar() async {
  await Isar.initializeIsarCore(download: true);
  final dir = await Directory.systemTemp.createTemp('cinetheque_isar_');
  return Isar.open(
    isarSchemas,
    directory: dir.path,
    name: 'test_${DateTime.now().microsecondsSinceEpoch}',
    inspector: false,
  );
}

Future<void> closeTestIsar(Isar isar) async {
  final dir = isar.directory;
  await isar.close(deleteFromDisk: true);
  if (dir != null) {
    try {
      await Directory(dir).delete(recursive: true);
    } on FileSystemException {
      // Nettoyage best effort.
    }
  }
}
