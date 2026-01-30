import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'src/core/app_startup/app_startup_provider.dart';
import 'src/core/routing/app_router.dart';
import 'src/core/utils/dio_provider.dart';
import 'src/core/utils/mock_api_setup.dart';
import 'src/core/theme/app_theme.dart';
import 'src/core/utils/locale_provider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dio = ref.watch(dioProvider);
    setupMockApi(dio);

    final startupState = ref.watch(appStartupProvider);
    final locale = ref.watch(appLocaleProvider);

    return startupState.when(
      data: (_) {
        final router = ref.watch(goRouterProvider);
        return MaterialApp.router(
          title: 'MP3 Management',
          routerConfig: router,
          theme: AppTheme.lightTheme,
          locale: locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
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
