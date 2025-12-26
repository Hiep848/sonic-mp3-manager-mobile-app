import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/social_login_buttons.dart';
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

    final authState = ref.watch(authControllerProvider);
    final formKey = useMemoized(() => GlobalKey<FormState>());

    ref.listen(authControllerProvider, (previous, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Lỗi: ${next.error}')));
      } else if (next is AsyncData) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đăng ký thành công! (Mock)')));
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
                  'Create Account',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const Gap(AppSizes.p32),
                CustomTextField(
                  controller: nameController,
                  label: 'Full Name',
                  prefixIcon: Icons.person,
                  validator: (val) =>
                      (val == null || val.isEmpty) ? 'Vui lòng nhập tên' : null,
                ),
                const Gap(AppSizes.p16),
                CustomTextField(
                  controller: emailController,
                  label: 'Email',
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Vui lòng nhập Email';
                    }
                    if (!val.contains('@')) {
                      return 'Email không hợp lệ';
                    }
                    return null;
                  },
                ),
                const Gap(AppSizes.p16),
                CustomTextField(
                  controller: passwordController,
                  label: 'Password',
                  prefixIcon: Icons.lock,
                  isPassword: true,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Vui lòng nhập mật khẩu';
                    }
                    if (val.length < 6) {
                      return 'Mật khẩu quá ngắn';
                    }
                    return null;
                  },
                ),
                const Gap(AppSizes.p16),
                CustomTextField(
                  controller: confirmPasswordController,
                  label: 'Confirm Password',
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Vui lòng xác nhận mật khẩu';
                    }
                    if (val != passwordController.text) {
                      return 'Mật khẩu không khớp';
                    }
                    return null;
                  },
                ),
                const Gap(AppSizes.p24),
                PrimaryButton(
                  text: 'SIGN UP',
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
                  onPressed: () => context.push('/login'),
                  child: const Text('Already have an account? Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
