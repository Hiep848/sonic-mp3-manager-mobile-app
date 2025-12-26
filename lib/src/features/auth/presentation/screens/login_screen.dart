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

// Dùng HookConsumerWidget để tận dụng useTextEditingController
class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController(text: 'hiep@gmail.com');
    final passwordController = useTextEditingController(text: '123456');

    // [QUAN TRỌNG] Lắng nghe thay đổi text để rebuild UI (enable/disable nút)
    useListenable(emailController);
    useListenable(passwordController);

    final authState = ref.watch(authControllerProvider);
    final formKey = useMemoized(() => GlobalKey<FormState>());

    // Logic kiểm tra nút Login có được bật hay không
    final isFormValid =
        emailController.text.isNotEmpty && passwordController.text.isNotEmpty;

    // Lắng nghe state để show snackbar hoặc chuyển màn hình
    ref.listen(authControllerProvider, (previous, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Lỗi: ${next.error}')));
      } else if (next is AsyncData) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đăng nhập thành công! (Mock)')));
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
                  'Welcome Back',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const Gap(AppSizes.p32),
                CustomTextField(
                  controller: emailController,
                  label: 'Email',
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập Email';
                    }
                    if (!value.contains('@')) {
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu';
                    }
                    if (value.length < 6) {
                      return 'Mật khẩu phải trên 6 ký tự';
                    }
                    return null;
                  },
                ),
                const Gap(AppSizes.p24),
                PrimaryButton(
                  text: 'LOGIN',
                  isLoading: authState.isLoading,
                  onPressed: isFormValid
                      ? () {
                          if (formKey.currentState!.validate()) {
                            ref.read(authControllerProvider.notifier).login(
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
                  onPressed: () => context.push('/register'),
                  child: const Text("Don't have an account? Sign Up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
