import '../error/exceptions.dart';
import '../error/failure_mapper.dart';
import '../error/failures.dart';
import '../network/network_info.dart';
import '../result/result.dart';

/// Donnée lue depuis le cache, avec sa date de mise en cache.
typedef CachedValue<T> = ({T data, DateTime cachedAt});

/// Stratégie « réseau d'abord, cache en secours » partagée par les
/// Repositories :
///
/// ```text
/// Connexion ? ── oui ──► TMDB ── ok ──► (mise à jour du cache) ──► Success
///     │                   │
///    non               échec
///     ▼                   ▼
///   Isar ◄────────────────┘ ── trouvé ──► Success(fromCache: true)
///     │
///  rien en cache ──► Error(CacheFailure | échec distant)
/// ```
///
/// [fetchRemote] est responsable d'écrire dans le cache (voir
/// [saveQuietly]) ; [readCache] renvoie `null` si rien n'est disponible.
Future<Result<T>> networkFirst<T>({
  required NetworkInfo networkInfo,
  required Future<T> Function() fetchRemote,
  required Future<CachedValue<T>?> Function() readCache,
}) async {
  Failure? remoteFailure;

  if (await networkInfo.isConnected) {
    try {
      return Success(await fetchRemote());
    } on AppException catch (e) {
      // Une interface réseau active ne garantit pas l'accès à Internet :
      // on tente le cache avant de conclure à l'échec.
      remoteFailure = mapExceptionToFailure(e);
    }
  }

  try {
    final cached = await readCache();
    if (cached != null) {
      return Success(cached.data, fromCache: true, cachedAt: cached.cachedAt);
    }
  } on AppException {
    // Cache illisible : on se rabat sur l'erreur la plus parlante ci-dessous.
  }

  // Hors ligne et rien en cache : « Aucune donnée hors ligne n'est disponible. »
  if (remoteFailure == null || remoteFailure is NetworkFailure) {
    return const Error(CacheFailure());
  }
  return Error(remoteFailure);
}

/// Écrit dans le cache sans jamais faire échouer l'appel réseau réussi :
/// une erreur d'écriture Isar ne doit pas masquer des données fraîches.
Future<void> saveQuietly(Future<void> Function() write) async {
  try {
    await write();
  } on CacheException {
    // Ignoré : le cache sera réécrit au prochain chargement.
  }
}
