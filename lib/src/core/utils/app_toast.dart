import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../constants/app_sizes.dart';
import '../widgets/primary_button.dart';
import '../routing/app_router.dart';

enum NotificationType { success, error, warning, info }

class AppToast {
  static OverlayEntry? _currentOverlay;
  static Timer? _overlayTimer;

  // ==================== OVERLAY NOTIFICATION (Bottom Fixed) ====================

  static void showError(BuildContext context, String message) {
    _showOverlayNotification(context, message, NotificationType.error);
  }

  static void showSuccess(BuildContext context, String message) {
    _showOverlayNotification(context, message, NotificationType.success);
  }

  static void showWarning(BuildContext context, String message) {
    _showOverlayNotification(context, message, NotificationType.warning);
  }

  static void showInfo(BuildContext context, String message) {
    _showOverlayNotification(context, message, NotificationType.info);
  }

  static void _showOverlayNotification(
    BuildContext context,
    String message,
    NotificationType type,
  ) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final overlayState = navigatorKey.currentState?.overlay;
      if (overlayState == null) return;

      // 1. Remove existing overlay/timer
      _overlayTimer?.cancel();
      _currentOverlay?.remove();
      _currentOverlay = null;

      final color = _getColor(type);
      final icon = _getIcon(type);

      // 2. Create new OverlayEntry
      _currentOverlay = OverlayEntry(
        builder: (context) => Positioned(
          bottom: MediaQuery.of(context).padding.bottom + 16,
          left: 16,
          right: 16,
          child: Material(
            color: Colors.transparent,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value.clamp(0.0, 1.0),
                  child: Transform.translate(
                    offset: Offset(0, (1 - value) * 20),
                    child: child,
                  ),
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(icon, color: Colors.white, size: 24),
                    const Gap(AppSizes.p12),
                    Expanded(
                      child: Text(
                        message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      // 3. Insert and schedule removal
      overlayState.insert(_currentOverlay!);

      _overlayTimer = Timer(const Duration(seconds: 3), () {
        _currentOverlay?.remove();
        _currentOverlay = null;
      });
    });
  }

  // ==================== RICH DIALOGS ====================

  static void showSuccessDialog(BuildContext context,
      {required String title,
      required String message,
      VoidCallback? onConfirm}) {
    showNotificationDialog(
      context: context,
      title: title,
      message: message,
      type: NotificationType.success,
      buttonText: 'Hoàn tất',
      onPressed: onConfirm,
    );
  }

  static void showErrorDialog(BuildContext context,
      {required String title,
      required String message,
      VoidCallback? onConfirm}) {
    showNotificationDialog(
      context: context,
      title: title,
      message: message,
      type: NotificationType.error,
      buttonText: 'Thử lại',
      onPressed: onConfirm,
    );
  }

  static void showWarningDialog(BuildContext context,
      {required String title,
      required String message,
      VoidCallback? onConfirm}) {
    showNotificationDialog(
      context: context,
      title: title,
      message: message,
      type: NotificationType.warning,
      buttonText: 'Xác nhận',
      onPressed: onConfirm,
    );
  }

  static void showInfoDialog(BuildContext context,
      {required String title,
      required String message,
      VoidCallback? onConfirm}) {
    showNotificationDialog(
      context: context,
      title: title,
      message: message,
      type: NotificationType.info,
      buttonText: 'Đóng',
      onPressed: onConfirm,
    );
  }

  static void showNotificationDialog({
    required BuildContext context,
    required String title,
    required String message,
    NotificationType type = NotificationType.info,
    required String buttonText,
    VoidCallback? onPressed,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final effectiveContext = navigatorKey.currentContext;
      if (effectiveContext == null) return;

      final color = _getColor(type);
      final icon = _getIcon(type);

      showDialog(
        context: effectiveContext,
        barrierDismissible: true,
        builder: (context) => Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.2),
                        offset: const Offset(0, 4),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Center(child: Icon(icon, color: color, size: 40)),
                ),
                const Gap(AppSizes.p24),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1.35,
                      ),
                ),
                const Gap(AppSizes.p12),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
                const Gap(AppSizes.p24),
                PrimaryButton(
                  text: buttonText,
                  onPressed: () {
                    Navigator.of(context).pop();
                    onPressed?.call();
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  // ==================== LOADING DIALOG ====================

  static void showLoading(BuildContext context, {String? message}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final effectiveContext = navigatorKey.currentContext;
      if (effectiveContext == null) return;

      showDialog(
        context: effectiveContext,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return PopScope(
            canPop: false,
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const Gap(20),
                    Expanded(
                      child: Text(
                        message ?? "Đang xử lý...",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  static void hideLoading(BuildContext context) {
    final effectiveContext = navigatorKey.currentContext;
    if (effectiveContext == null) return;

    if (Navigator.of(effectiveContext).canPop()) {
      Navigator.of(effectiveContext).pop();
    }
  }

  // ==================== HELPERS ====================

  static Color _getColor(NotificationType type) {
    return switch (type) {
      NotificationType.success => const Color(0xFF4CAF50),
      NotificationType.error => const Color(0xFFF44336),
      NotificationType.warning => const Color(0xFFFF9800),
      NotificationType.info => const Color(0xFF2196F3),
    };
  }

  static IconData _getIcon(NotificationType type) {
    return switch (type) {
      NotificationType.success => Icons.check_circle_outline,
      NotificationType.error => Icons.error_outline,
      NotificationType.warning => Icons.warning_amber_rounded,
      NotificationType.info => Icons.info_outline,
    };
  }
}
