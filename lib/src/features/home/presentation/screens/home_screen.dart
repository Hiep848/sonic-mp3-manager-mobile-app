import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../audio/presentation/audio_player_controller.dart';
import '../../../audio/presentation/mini_player.dart';

class HomeScreen extends HookConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const HomeScreen({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    // Check if we should show mini player
    final audioState = ref.watch(audioPlayerProvider);
    // Show if not on Home tab (0) AND track exists
    final showMiniPlayer =
        navigationShell.currentIndex != 0 && audioState.currentTrack != null;

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

    return Scaffold(
      body: navigationShell, // The child route (Feed, Album, Profile)
      bottomSheet: showMiniPlayer ? const MiniPlayer() : null,
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (index) {
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
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
      floatingActionButton: navigationShell.currentIndex == 0
          ? FloatingActionButton(
              onPressed: () => context.push('/upload'),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
