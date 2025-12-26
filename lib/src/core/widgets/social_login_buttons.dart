import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../gen/assets.gen.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Or continue with',
                  style: TextStyle(color: Colors.grey)),
            ),
            Expanded(child: Divider()),
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
                onTap: () {},
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
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}

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
