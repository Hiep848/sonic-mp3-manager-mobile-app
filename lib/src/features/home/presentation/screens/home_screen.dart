import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../diary/presentation/feed_screen.dart';
import '../../../diary/presentation/profile_screen.dart';
import '../../../diary/presentation/album_screen.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // State management for bottom navigation
    final currentIndex = useState(0);
    final l10n = AppLocalizations.of(context)!;

    // Lắng nghe logout state
    ref.listen(authControllerProvider, (previous, next) {
      if (next is AsyncLoading) {
        AppToast.showLoading(context, message: l10n.settingsLogoutConfirm);
      } else {
        if (previous is AsyncLoading) {
          AppToast.hideLoading(context);
        }
        if (next is AsyncError) {
          AppToast.showErrorDialog(
            context,
            title: l10n.settingsLogoutError,
            message: '${next.error}',
          );
        } else if (next is AsyncData && previous is AsyncLoading) {
          AppToast.showSuccess(context, l10n.settingsLogoutSuccess);
        }
      }
    });

    final screens = [
      const FeedScreen(),
      const AlbumScreen(),
      const ProfileScreen(), // Now Acts as Settings
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex.value,
        children: screens,
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  12)), // "Smaller burble" - rect instead of pill
          // Or user specifically meant the ripple? Material 3 NavigationBar handles this well.
          // I'll stick to a standard shape but maybe slightly more boxy to reduce "fatness" of the pill if that's the issue.
          // Actually, standard pill is fine. If they mean the splash radius, NavigationBar doesn't have it exposed easy.
          // But changing BottomNavigationBar to NavigationBar is the requested move implied by "modern settings".
        ),
        child: NavigationBar(
          selectedIndex: currentIndex.value,
          onDestinationSelected: (index) {
            currentIndex.value = index;
          },
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              label: l10n.navJournal,
            ),
            NavigationDestination(
              icon: const Icon(Icons.photo_album_outlined),
              selectedIcon: const Icon(Icons.photo_album),
              label: l10n.navAlbums,
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings_outlined),
              selectedIcon: const Icon(Icons.settings),
              label: l10n.navSettings,
            ),
          ],
        ),
      ),
      floatingActionButton: currentIndex.value == 0
          ? FloatingActionButton(
              onPressed: () => context.push('/upload'),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
