import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/social_login_buttons.dart';
import '../../../../../l10n/app_localizations.dart';
import '../controllers/auth_controller.dart';

// Dùng HookConsumerWidget để tận dụng useTextEditingController
class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    // [QUAN TRỌNG] Lắng nghe thay đổi text để rebuild UI (enable/disable nút)
    useListenable(emailController);
    useListenable(passwordController);

    final authState = ref.watch(authControllerProvider);
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final l10n = AppLocalizations.of(context)!;

    // Logic kiểm tra nút Login có được bật hay không
    final isFormValid =
        emailController.text.isNotEmpty && passwordController.text.isNotEmpty;

    // Lắng nghe state để show snackbar hoặc chuyển màn hình
    ref.listen(authControllerProvider, (previous, next) {
      // 1. Nếu đang Loading -> Hiện Dialog
      if (next is AsyncLoading) {
        AppToast.showLoading(context, message: l10n.authLoggingIn);
      }
      // 2. Nếu xong (Data hoặc Error) -> Tắt Dialog trước
      else {
        // Chỉ tắt nếu trước đó đang loading (tránh tắt nhầm màn hình khác)
        if (previous is AsyncLoading) {
          AppToast.hideLoading(context);
        }

        // 3. Sau đó mới hiện thông báo
        if (next is AsyncError) {
          AppToast.showErrorDialog(
            context,
            title: l10n.authLoginTitle,
            message: '${next.error}',
          );
        } else if (next is AsyncData) {
          AppToast.showSuccess(context, l10n.authLoginSuccess);
        }
      }
    });

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.p24),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.authWelcome,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const Gap(AppSizes.p32),
                CustomTextField(
                  controller: emailController,
                  label: l10n.authEmail,
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.authEnterEmail;
                    }
                    if (!value.contains('@')) {
                      return l10n.authInvalidEmail;
                    }
                    return null;
                  },
                ),
                const Gap(AppSizes.p16),
                CustomTextField(
                  controller: passwordController,
                  label: l10n.authPassword,
                  prefixIcon: Icons.lock,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.authEnterPassword;
                    }
                    if (value.length < 6) {
                      return l10n.authShortPassword;
                    }
                    return null;
                  },
                ),
                const Gap(AppSizes.p24),
                PrimaryButton(
                  text: l10n.authLoginButton,
                  isLoading: authState.isLoading,
                  onPressed: isFormValid
                      ? () {
                          if (formKey.currentState!.validate()) {
                            ref
                                .read(authControllerProvider.notifier)
                                .traditionalLogin(
                                  emailController.text,
                                  passwordController.text,
                                );
                          }
                        }
                      : null,
                ),
                const Gap(AppSizes.p24),
                const SocialLoginButtons(),
                const Gap(AppSizes.p16),
                TextButton(
                  onPressed: () => context.go('/register'),
                  child: Text(l10n.authNoAccount),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
