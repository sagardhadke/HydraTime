import 'package:flutter/material.dart';
import 'package:hydra_time/core/constants/app_colors.dart';

class SnackBarHelper {
  static void showSuccess(BuildContext context, String message) {
    _showSnackBar(context, message, AppColors.successColor, Icons.check_circle);
  }

  static void showError(BuildContext context, String message) {
    _showSnackBar(context, message, Colors.red, Icons.error_outline);
  }

  static void showWarning(BuildContext context, String message) {
    _showSnackBar(context, message, Colors.amber, Icons.warning_amber_rounded);
  }

  static void showInfo(BuildContext context, String message) {
    _showSnackBar(context, message, AppColors.primaryColor, Icons.info_outline);
  }

  static void _showSnackBar(
    BuildContext context,
    String message,
    Color color,
    IconData icon,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
