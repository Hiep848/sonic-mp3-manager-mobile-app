import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../gen/assets.gen.dart';
import '../../features/auth/presentation/controllers/google_sign_in_controller.dart';
import '../utils/app_toast.dart';
import '../../../../l10n/app_localizations.dart';

class SocialLoginButtons extends ConsumerWidget {
  const SocialLoginButtons({super.key});

  Future<void> _handleGoogleLogin(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(googleSignInControllerProvider.notifier).loginViaBackend();
    } on GoogleSignInException catch (e) {
      if (context.mounted) {
        AppToast.showErrorDialog(
          context,
          title: AppLocalizations.of(context)!.authLoginTitle,
          message: e.toString(),
        );
        // ignore: avoid_print
        print(
            'Google Sign In error: code: ${e.code.name} description:${e.description} details:${e.details}');
      }
    } on StateError {
      if (context.mounted) {
        AppToast.showErrorDialog(
          context,
          title: AppLocalizations.of(context)!.socialGoogleError,
          message: AppLocalizations.of(context)!.socialAuthCodeError,
        );
      }
    } catch (e) {
      if (context.mounted) {
        AppToast.showErrorDialog(
          context,
          title: 'Lỗi',
          message: e.toString(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final googleInit = ref.watch(googleSignInControllerProvider);
    final isGoogleReady = googleInit is AsyncData<void>;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(l10n.socialOrContinue,
                  style: const TextStyle(color: Colors.grey)),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        const Gap(24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: _SocialButton(
                iconWidget: SvgPicture.asset(
                  Assets.svg.icGoogle,
                  width: 20,
                  height: 20,
                ),
                label: 'Google',
                color: Colors.white,
                textColor: Colors.red,
                onTap: isGoogleReady
                    ? () => _handleGoogleLogin(context, ref)
                    : () {
                        if (context.mounted) {
                          AppToast.showInfo(context, l10n.socialSignInInit);
                        }
                      },
              ),
            ),
            const Gap(16),
            Expanded(
              child: _SocialButton(
                iconWidget: SvgPicture.asset(
                  Assets.svg.icFacebook,
                  width: 20,
                  height: 20,
                ),
                label: 'Facebook',
                color: Colors.blue.shade50,
                textColor: Colors.blue.shade800,
                onTap: () {
                  // TODO: Implement Facebook Login later
                  AppToast.showInfo(context, l10n.socialFeatureDev);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Giữ nguyên widget con này
class _SocialButton extends StatelessWidget {
  final Widget iconWidget;
  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  const _SocialButton({
    required this.iconWidget,
    required this.label,
    required this.color,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300), // Thêm viền cho đẹp
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget,
            const Gap(8),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
