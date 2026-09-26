import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/storage/isar_service.dart';
import '../../../../shared/models/fetched.dart';
import '../../data/local/actor_local_data_source.dart';
import '../../data/remote/actor_remote_data_source.dart';
import '../../data/repositories/actor_repository_impl.dart';
import '../../domain/entities/actor_details.dart';
import '../../domain/repositories/actor_repository.dart';
import '../../domain/usecases/get_actor_details.dart';

final actorRemoteDataSourceProvider = Provider<ActorRemoteDataSource>(
  (ref) => TmdbActorRemoteDataSource(ref.watch(tmdbDioProvider)),
);

final actorLocalDataSourceProvider = Provider<ActorLocalDataSource>(
  (ref) => IsarActorLocalDataSource(ref.watch(isarProvider)),
);

final actorRepositoryProvider = Provider<ActorRepository>(
  (ref) => ActorRepositoryImpl(
    remote: ref.watch(actorRemoteDataSourceProvider),
    local: ref.watch(actorLocalDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  ),
);

final getActorDetailsProvider = Provider(
  (ref) => GetActorDetails(ref.watch(actorRepositoryProvider)),
);

/// Fiche acteur : loading / success (Fetched) / error (Failure).
final actorDetailsProvider = FutureProvider.autoDispose
    .family<Fetched<ActorDetails>, int>(
      (ref, actorId) => ref.watch(getActorDetailsProvider)(actorId).orThrow(),
    );
