import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/actors/presentation/pages/actor_details_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/favorites/presentation/pages/favorites_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/movies/domain/entities/movie.dart';
import '../../features/movies/domain/entities/movie_category.dart';
import '../../features/movies/domain/entities/movie_details.dart';
import '../../features/movies/presentation/pages/movie_details_page.dart';
import '../../features/movies/presentation/pages/movie_list_page.dart';
import '../../features/movies/presentation/pages/search_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../shared/widgets/app_navigation_shell.dart';
import 'route_names.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final appRouterProvider = Provider<GoRouter>((ref) {
  // Ré-évalue les redirections à chaque changement de session
  // (connexion, déconnexion, expiration du refresh token).
  final sessionChanges = ValueNotifier<int>(0);
  ref.listen(authStateProvider, (_, _) => sessionChanges.value++);
  ref.onDispose(sessionChanges.dispose);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RoutePaths.splash,
    debugLogDiagnostics: kDebugMode,
    refreshListenable: sessionChanges,
    redirect: (context, state) {
      final location = state.matchedLocation;
      // Le Splash décide lui-même de la destination.
      if (location == RoutePaths.splash) return null;

      // Lecture directe de la session (toujours à jour) : un provider dérivé
      // lu avec ref.read peut renvoyer une valeur périmée en Riverpod 3.
      final isLoggedIn = ref.read(getCurrentUserProvider)() != null;
      final isOnAuthPage = location.startsWith(RoutePaths.login);

      if (!isLoggedIn && !isOnAuthPage) return RoutePaths.login;
      if (isLoggedIn && isOnAuthPage) return RoutePaths.home;
      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RoutePaths.login,
        builder: (context, state) => const LoginPage(),
        routes: [
          GoRoute(
            path: 'register',
            builder: (context, state) => const RegisterPage(),
          ),
        ],
      ),

      // Onglets principaux (barre de navigation persistante).
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) =>
            AppNavigationShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.home,
                builder: (context, state) => const HomePage(),
                routes: [
                  GoRoute(
                    path: RoutePaths.movieListSegment,
                    redirect: (context, state) =>
                        MovieCategory.fromKey(
                              state.pathParameters['category']!,
                            ) ==
                            null
                        ? RoutePaths.home
                        : null,
                    builder: (context, state) => MovieListPage(
                      category: MovieCategory.fromKey(
                        state.pathParameters['category']!,
                      )!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.search,
                builder: (context, state) => const SearchPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.favorites,
                builder: (context, state) => const FavoritesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.profile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),

      // Écrans plein écran, poussés au-dessus des onglets.
      GoRoute(
        path: RoutePaths.movieDetails,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => MovieDetailsPage(
          movieId: int.tryParse(state.pathParameters['id'] ?? '') ?? -1,
          preview: state.extra is Movie ? state.extra! as Movie : null,
        ),
      ),
      GoRoute(
        path: RoutePaths.actorDetails,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => ActorDetailsPage(
          actorId: int.tryParse(state.pathParameters['id'] ?? '') ?? -1,
          preview: state.extra is CastMember
              ? state.extra! as CastMember
              : null,
        ),
      ),
    ],
  );
});
