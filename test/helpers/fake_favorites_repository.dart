import 'dart:async';

import 'package:flutter_app_production_ready/core/result/result.dart';
import 'package:flutter_app_production_ready/features/favorites/domain/entities/favorite.dart';
import 'package:flutter_app_production_ready/features/favorites/domain/repositories/favorites_repository.dart';

/// Favoris en mémoire, réactifs comme la version Isar.
class FakeFavoritesRepository implements FavoritesRepository {
  FakeFavoritesRepository([List<Favorite> initial = const []])
    : _items = [...initial];

  final List<Favorite> _items;
  final _changes = StreamController<void>.broadcast();

  List<Favorite> get items => List.unmodifiable(_items);

  Stream<T> _watch<T>(T Function() read) async* {
    yield read();
    yield* _changes.stream.map((_) => read());
  }

  @override
  Stream<List<Favorite>> watchFavorites() =>
      _watch(() => [..._items]..sort((a, b) => b.addedAt.compareTo(a.addedAt)));

  @override
  Stream<bool> watchIsFavorite(int movieId) =>
      _watch(() => _items.any((f) => f.movieId == movieId));

  @override
  Future<Result<void>> addFavorite(Favorite favorite) async {
    _items
      ..removeWhere((f) => f.movieId == favorite.movieId)
      ..add(favorite);
    _changes.add(null);
    return const Success(null);
  }

  @override
  Future<Result<void>> removeFavorite(int movieId) async {
    _items.removeWhere((f) => f.movieId == movieId);
    _changes.add(null);
    return const Success(null);
  }

  @override
  Future<Result<int>> countFavorites() async => Success(_items.length);
}
