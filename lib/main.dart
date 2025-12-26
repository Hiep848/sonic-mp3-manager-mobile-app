import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/core/app_startup/app_startup_provider.dart'; // Import
import 'src/core/routing/app_router.dart';
import 'src/core/utils/dio_provider.dart';
import 'src/core/utils/mock_api_setup.dart';
import 'src/core/theme/app_theme.dart'; // Nếu đã tạo theme

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Setup Mock
    final dio = ref.watch(dioProvider);
    setupMockApi(dio);

    // 2. [QUAN TRỌNG] Khởi chạy AppStartup logic
    // Lắng nghe provider này, nếu nó đang load thì hiện màn hình chờ (Splash)
    final startupState = ref.watch(appStartupProvider);

    return startupState.when(
      data: (_) {
        // Load xong -> Vào App chính với Router
        final router = ref.watch(goRouterProvider);
        return MaterialApp.router(
          title: 'MP3 Management',
          routerConfig: router,
          theme: AppTheme.lightTheme, // Nếu có
        );
      },
      loading: () => const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      error: (e, st) => MaterialApp(
        home: Scaffold(body: Center(child: Text('Lỗi khởi động: $e'))),
      ),
    );
  }
}
