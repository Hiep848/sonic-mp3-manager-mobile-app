import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/upload/presentation/screens/upload_screen.dart';
import '../../features/diary/presentation/detail_screen.dart';
import '../../features/diary/presentation/search_screen.dart';
import '../../features/diary/presentation/feed_screen.dart'; // import FeedScreen
import '../../features/diary/presentation/profile_screen.dart'; // import ProfileScreen
import '../../features/album/presentation/album_screen.dart'; // import AlbumScreen
import '../../features/album/presentation/album_detail_screen.dart';
import '../app_startup/app_startup_provider.dart';

part 'app_router.g.dart';

final navigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  // Lắng nghe trạng thái login
  final isLoggedIn = ref.watch(isLoggedInProvider);

  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/home',
    redirect: (context, state) {
      final isAuthRoute =
          state.uri.path == '/login' || state.uri.path == '/register';

      if (!isLoggedIn) {
        return isAuthRoute ? null : '/login';
      }

      if (isAuthRoute) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      // StatefulShellRoute for persistent bottom navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return HomeScreen(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Feed (Home)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const FeedScreen(),
                routes: [
                  GoRoute(
                    path: 'detail/:id',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return DetailScreen(postId: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          // Branch 1: Albums
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/albums',
                builder: (context, state) => const AlbumScreen(),
                routes: [
                  GoRoute(
                    path: 'detail/:id',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      final name = state.extra as String? ?? 'Album';
                      return AlbumDetailScreen(albumId: id, albumName: name);
                    },
                  ),
                ],
              ),
            ],
          ),
          // Branch 2: Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      // Standalone routes (not in bottom nav)
      GoRoute(
        path: '/upload',
        builder: (context, state) => const UploadScreen(),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/detail/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return DetailScreen(postId: id);
        },
      ),
    ],
  );
}
