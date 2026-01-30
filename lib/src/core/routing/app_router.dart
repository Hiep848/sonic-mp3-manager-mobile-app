import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/upload/presentation/screens/upload_screen.dart';
import '../../features/diary/presentation/detail_screen.dart';
import '../../features/diary/presentation/search_screen.dart';
import '../app_startup/app_startup_provider.dart';

part 'app_router.g.dart';

final navigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  // Lắng nghe trạng thái login
  final isLoggedIn = ref.watch(isLoggedInProvider);

  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/home', // Mặc định muốn vào Home
    redirect: (context, state) {
      // Logic chặn cửa:
      // Nếu đang ở trang auth (login hoặc register)
      final isAuthRoute =
          state.uri.path == '/login' || state.uri.path == '/register';

      if (!isLoggedIn) {
        // Chưa login -> Đá về trang login (nếu chưa ở đó)
        return isAuthRoute ? null : '/login';
      }

      // Đã login -> Nếu đang ở trang auth thì đá về home
      if (isAuthRoute) {
        return '/home';
      }

      return null; // Cho phép đi tiếp
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
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
