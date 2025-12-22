import 'package:flutter/material.dart';
import 'package:hydra_time/core/constants/app_colors.dart';

enum SnackBarType { success, error, warning, info }

class SnackBarHelper {
  static void show({
    required BuildContext context,
    required String message,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    Color backgroundColor;
    IconData icon;

    switch (type) {
      case SnackBarType.success:
        backgroundColor = AppColors.successColor;
        icon = Icons.check_circle;
        break;
      case SnackBarType.error:
        backgroundColor = AppColors.errorColor;
        icon = Icons.error;
        break;
      case SnackBarType.warning:
        backgroundColor = AppColors.warningColor;
        icon = Icons.warning;
        break;
      case SnackBarType.info:
        backgroundColor = AppColors.primaryColor;
        icon = Icons.info;
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        action: actionLabel != null && onAction != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: onAction,
              )
            : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    show(context: context, message: message, type: SnackBarType.success);
  }

  static void showError(BuildContext context, String message) {
    show(context: context, message: message, type: SnackBarType.error);
  }

  static void showWarning(BuildContext context, String message) {
    show(context: context, message: message, type: SnackBarType.warning);
  }

  static void showInfo(BuildContext context, String message) {
    show(context: context, message: message, type: SnackBarType.info);
  }
}