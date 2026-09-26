import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_app_production_ready/core/result/result.dart';
import 'package:flutter_app_production_ready/features/movies/domain/entities/movie.dart';
import 'package:flutter_app_production_ready/features/movies/domain/entities/paginated_movies.dart';
import 'package:flutter_app_production_ready/features/movies/presentation/providers/movie_providers.dart';
import 'package:flutter_app_production_ready/features/movies/presentation/providers/movie_search_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_movie_repository.dart';

/// Repository dont on contrôle l'ordre des réponses.
class _ControlledRepository extends FakeMovieRepository {
  final pending = <String, Completer<Result<PaginatedMovies>>>{};

  @override
  Future<Result<PaginatedMovies>> searchMovies(String query, {int page = 1}) {
    searchCalls.add(query);
    return (pending[query] = Completer()).future;
  }

  void answer(String query, List<Movie> movies) => pending[query]!.complete(
    Success(
      PaginatedMovies(
        movies: movies,
        page: 1,
        totalPages: 1,
        totalResults: movies.length,
      ),
    ),
  );
}

void main() {
  const nuit = Movie(id: 1, title: 'La Nuit des masques');
  const nu = Movie(id: 2, title: 'Nu');

  ProviderContainer containerWith(FakeMovieRepository repo) {
    final container = ProviderContainer(
      retry: (_, _) => null,
      overrides: [movieRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);
    // Garde le contrôleur actif, comme le ferait l'écran.
    container.listen(movieSearchProvider, (_, _) {});
    return container;
  }

  test('anti-rebond : une seule requête pour une saisie rapide', () {
    fakeAsync((async) {
      final repo = FakeMovieRepository()..searchResults['nuit'] = [nuit];
      final container = containerWith(repo);
      final controller = container.read(movieSearchProvider.notifier);

      for (final text in ['n', 'nu', 'nui', 'nuit']) {
        controller.onQueryChanged(text);
        async.elapse(const Duration(milliseconds: 150));
      }
      expect(repo.searchCalls, isEmpty);

      async.elapse(const Duration(milliseconds: 400));

      expect(repo.searchCalls, ['nuit']);
      final state = container.read(movieSearchProvider);
      expect(state.status, SearchStatus.success);
      expect(state.movies, [nuit]);
    });
  });

  test('requête trop courte : aucun appel, état initial', () {
    fakeAsync((async) {
      final repo = FakeMovieRepository();
      final container = containerWith(repo);

      container.read(movieSearchProvider.notifier).onQueryChanged('n');
      async.elapse(const Duration(seconds: 1));

      expect(repo.searchCalls, isEmpty);
      expect(container.read(movieSearchProvider).status, SearchStatus.idle);
    });
  });

  test('une réponse périmée n’écrase pas la recherche en cours', () async {
    final repo = _ControlledRepository();
    final container = containerWith(repo);
    final controller = container.read(movieSearchProvider.notifier);

    unawaited(controller.submit('nu'));
    unawaited(controller.submit('nuit'));

    // « nuit » répond en premier, puis l'ancienne requête « nu ».
    repo.answer('nuit', [nuit]);
    await Future<void>.delayed(Duration.zero);
    repo.answer('nu', [nu]);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(movieSearchProvider);
    expect(state.query, 'nuit');
    expect(state.movies, [nuit]);
  });

  test('effacer le champ annule la recherche en vol', () async {
    final repo = _ControlledRepository();
    final container = containerWith(repo);
    final controller = container.read(movieSearchProvider.notifier);

    unawaited(controller.submit('nuit'));
    controller.onQueryChanged('');
    repo.answer('nuit', [nuit]);
    await Future<void>.delayed(Duration.zero);

    expect(container.read(movieSearchProvider).status, SearchStatus.idle);
  });
}
