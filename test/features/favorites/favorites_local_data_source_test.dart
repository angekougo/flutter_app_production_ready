import 'package:flutter_app_production_ready/features/favorites/data/local/favorites_local_data_source.dart';
import 'package:flutter_app_production_ready/features/favorites/data/local/models/favorite_movie.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';

import '../../helpers/isar_test_helper.dart';

FavoriteMovie favorite(String ownerId, int movieId, {DateTime? addedAt}) =>
    FavoriteMovie()
      ..ownerId = ownerId
      ..movieId = movieId
      ..title = 'Film $movieId'
      ..addedAt = addedAt ?? DateTime.now();

void main() {
  late Isar isar;
  late IsarFavoritesLocalDataSource local;

  setUp(() async {
    isar = await openTestIsar();
    local = IsarFavoritesLocalDataSource(isar);
  });

  tearDown(() => closeTestIsar(isar));

  test('chaque utilisateur a ses propres favoris', () async {
    await local.addFavorite(favorite('awa', 1));
    await local.addFavorite(favorite('awa', 2));
    await local.addFavorite(favorite('theo', 1));

    expect(await local.countFavorites('awa'), 2);
    expect(await local.countFavorites('theo'), 1);
    expect(await local.isFavorite('theo', 2), isFalse);
  });

  test('ajouter deux fois le même film ne crée pas de doublon', () async {
    await local.addFavorite(favorite('awa', 1));
    await local.addFavorite(favorite('awa', 1));

    expect(await local.countFavorites('awa'), 1);
  });

  test('tri du plus récent au plus ancien, puis suppression', () async {
    final now = DateTime.now();
    await local.addFavorite(
      favorite('awa', 1, addedAt: now.subtract(const Duration(days: 1))),
    );
    await local.addFavorite(favorite('awa', 2, addedAt: now));

    final favorites = await local.getFavorites('awa');
    expect(favorites.map((f) => f.movieId), [2, 1]);

    await local.removeFavorite('awa', 2);
    expect(await local.isFavorite('awa', 2), isFalse);
    expect(await local.countFavorites('awa'), 1);
  });

  test('watchFavorites réémet à chaque changement', () async {
    final emissions = local
        .watchFavorites('awa')
        .map((list) => list.length)
        .take(3)
        .toList();

    await Future<void>.delayed(const Duration(milliseconds: 50));
    await local.addFavorite(favorite('awa', 1));
    await Future<void>.delayed(const Duration(milliseconds: 50));
    await local.removeFavorite('awa', 1);

    expect(await emissions, [0, 1, 0]);
  });
}
