import 'package:equatable/equatable.dart';

import '../../core/result/result.dart';

/// Donnée prête pour l'UI, avec sa provenance : permet d'afficher la
/// bannière hors ligne et la mention « EN CACHE ».
///
/// Égalité par valeur : un provider qui recalcule le même résultat ne
/// reconstruit pas les widgets qui l'observent (Riverpod compare avec `==`).
class Fetched<T> extends Equatable {
  const Fetched(this.data, {this.fromCache = false, this.cachedAt});

  final T data;
  final bool fromCache;
  final DateTime? cachedAt;

  @override
  List<Object?> get props => [data, fromCache, cachedAt];
}

extension ResultToFetched<T> on Future<Result<T>> {
  /// Convertit le [Result] d'un use case pour un provider Riverpod :
  /// succès → [Fetched] ; échec → lève le `Failure` (→ `AsyncError`).
  Future<Fetched<T>> orThrow() async => switch (await this) {
    Success(:final data, :final fromCache, :final cachedAt) => Fetched(
      data,
      fromCache: fromCache,
      cachedAt: cachedAt,
    ),
    Error(:final failure) => throw failure,
  };
}
