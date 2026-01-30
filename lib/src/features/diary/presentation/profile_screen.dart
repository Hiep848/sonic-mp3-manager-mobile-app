import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../data/mock_user_repository.dart';
import '../domain/models/user_model.dart';
import '../../auth/presentation/controllers/auth_controller.dart';
import '../../../core/utils/app_toast.dart';
import '../../../core/utils/locale_provider.dart';

import '../../../../l10n/app_localizations.dart';

final userProvider = FutureProvider<User>((ref) async {
  final repository = ref.watch(mockUserRepositoryProvider);
  return repository.getCurrentUser();
});

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    // Auth Controller for Logout
    final authController = ref.read(authControllerProvider.notifier);

    // Theme State (Mock)
    final isDarkMode = useState(false);

    // Locale State
    final currentLocale = ref.watch(appLocaleProvider);
    final localeNotifier = ref.read(appLocaleProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
      ),
      body: userAsync.when(
        data: (user) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // User Info
            _buildUserProfile(context, user),
            const SizedBox(height: 24),

            // Appearance Section
            _buildSectionHeader(context, l10n.settingsTheme),
            SwitchListTile(
              title: Text(l10n.settingsThemeDark),
              subtitle: Text(l10n.settingsThemeDarkSub),
              value: isDarkMode.value,
              onChanged: (val) => isDarkMode.value = val,
              secondary: const Icon(Icons.dark_mode_outlined),
            ),

            const Divider(),

            // Language Section
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(l10n.settingsLanguage),
              subtitle: Text(l10n.settingsLanguageSub),
              trailing: Text(
                currentLocale.languageCode == 'vi' ? 'Tiếng Việt' : 'English',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              onTap: () {
                localeNotifier.toggleLocale();
              },
            ),

            const Divider(),

            // Security Section
            _buildSectionHeader(context, l10n.settingsSecurity),
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: Text(l10n.settingsChangePassword),
              subtitle: Text(l10n.settingsChangePasswordSub),
              onTap: () {
                AppToast.showInfo(context, l10n.detailEdit);
              },
            ),

            const SizedBox(height: 40),

            // Logout
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  AppToast.showLoading(context,
                      message: l10n.settingsLogoutConfirm);
                  Future.delayed(const Duration(seconds: 1), () {
                    authController.logout();
                    AppToast.showSuccess(context, l10n.settingsLogoutSuccess);
                  });
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: Text(l10n.settingsLogout,
                    style: const TextStyle(color: Colors.red)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            Center(child: Text('${l10n.commonError(err.toString())}')),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildUserProfile(BuildContext context, User user) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage:
                user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
            child: user.avatarUrl == null
                ? const Icon(Icons.person, size: 30)
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.username,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                if (user.email != null)
                  Text(
                    user.email!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} // End Class
