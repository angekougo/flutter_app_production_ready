import '../error/failures.dart';

/// Résultat d'une opération du Domain : soit un succès, soit un [Failure].
///
/// Évite de propager des exceptions jusqu'à l'UI et oblige l'appelant à
/// traiter les deux cas (pattern matching exhaustif grâce à `sealed`).
sealed class Result<T> {
  const Result();

  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) => switch (this) {
    Success<T>(:final data) => success(data),
    Error<T>(failure: final f) => failure(f),
  };

  bool get isSuccess => this is Success<T>;
  T? get dataOrNull => switch (this) {
    Success<T>(:final data) => data,
    Error<T>() => null,
  };
}

final class Success<T> extends Result<T> {
  const Success(this.data, {this.fromCache = false, this.cachedAt});

  final T data;

  /// `true` si les données proviennent d'Isar (mode hors ligne).
  final bool fromCache;

  /// Date de mise en cache, lorsque [fromCache] est vrai.
  final DateTime? cachedAt;
}

final class Error<T> extends Result<T> {
  const Error(this.failure);
  final Failure failure;
}
