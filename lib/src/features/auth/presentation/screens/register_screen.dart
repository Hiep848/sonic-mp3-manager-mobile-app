import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/social_login_buttons.dart';
import '../../../../../l10n/app_localizations.dart';
import '../controllers/auth_controller.dart';

class RegisterScreen extends HookConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();

    // Lắng nghe để bật/tắt nút
    useListenable(nameController);
    useListenable(emailController);
    useListenable(passwordController);
    useListenable(confirmPasswordController);
    final l10n = AppLocalizations.of(context)!;

    final authState = ref.watch(authControllerProvider);
    final formKey = useMemoized(() => GlobalKey<FormState>());

    ref.listen(authControllerProvider, (previous, next) {
      // 1. Nếu đang Loading -> Hiện Dialog
      if (next is AsyncLoading) {
        AppToast.showLoading(context, message: l10n.authCreatingAccount);
      }
      // 2. Nếu xong (Data hoặc Error) -> Tắt Dialog trước
      else {
        // Chỉ tắt nếu trước đó đang loading
        if (previous is AsyncLoading) {
          AppToast.hideLoading(context);
        }

        // 3. Sau đó mới hiện thông báo
        if (next is AsyncError) {
          AppToast.showErrorDialog(
            context,
            title: l10n.authRegisterError,
            message: '${next.error}',
          );
        } else if (next is AsyncData) {
          AppToast.showSuccessDialog(
            context,
            title: 'Thành công',
            message: l10n.authRegisterSuccess,
          );
        }
      }
    });

    // Check xem đã điền đủ chưa
    final isFormFilled = nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty;

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
                  l10n.authRegisterTitle,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const Gap(AppSizes.p32),
                CustomTextField(
                  controller: nameController,
                  label: l10n.authFullName,
                  prefixIcon: Icons.person,
                  validator: (val) =>
                      (val == null || val.isEmpty) ? l10n.authEnterName : null,
                ),
                const Gap(AppSizes.p16),
                CustomTextField(
                  controller: emailController,
                  label: l10n.authEmail,
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return l10n.authEnterEmail;
                    }
                    if (!val.contains('@')) {
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
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return l10n.authEnterPassword;
                    }
                    if (val.length < 6) {
                      return l10n.authShortPassword;
                    }
                    return null;
                  },
                ),
                const Gap(AppSizes.p16),
                CustomTextField(
                  controller: confirmPasswordController,
                  label: l10n.authConfirmPassword,
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return l10n.authConfirmPassEmpty;
                    }
                    if (val != passwordController.text) {
                      return l10n.authPassMismatch;
                    }
                    return null;
                  },
                ),
                const Gap(AppSizes.p24),
                PrimaryButton(
                  text: l10n.authSignUpButton,
                  isLoading: authState.isLoading,
                  onPressed: isFormFilled
                      ? () {
                          if (formKey.currentState!.validate()) {
                            ref.read(authControllerProvider.notifier).register(
                                  emailController.text,
                                  passwordController.text,
                                  nameController.text,
                                );
                          }
                        }
                      : null,
                ),
                const Gap(AppSizes.p24),
                const SocialLoginButtons(),
                const Gap(AppSizes.p16),
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: Text(l10n.authHaveAccount),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
