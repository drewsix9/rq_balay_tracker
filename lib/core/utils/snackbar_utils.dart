import 'package:flutter/material.dart';

enum SnackBarType { success, error, warning, info }

class SnackBarUtils {
  static void showSnackBar({
    required BuildContext context,
    required String message,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    Color backgroundColor;
    IconData icon;
    String title;

    switch (type) {
      case SnackBarType.success:
        backgroundColor = Colors.green[600]!;
        icon = Icons.check_circle;
        title = 'Success';
        break;
      case SnackBarType.error:
        backgroundColor = Colors.red[600]!;
        icon = Icons.error;
        title = 'Error';
        break;
      case SnackBarType.warning:
        backgroundColor = Colors.orange[600]!;
        icon = Icons.warning;
        title = 'Warning';
        break;
      case SnackBarType.info:
        backgroundColor = Colors.blue[600]!;
        icon = Icons.info;
        title = 'Info';
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  Text(message, style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  // Convenience methods for quick access
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    showSnackBar(
      context: context,
      message: message,
      type: SnackBarType.success,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  static void showError(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    showSnackBar(
      context: context,
      message: message,
      type: SnackBarType.error,
      duration:
          duration ?? const Duration(seconds: 5), // Longer duration for errors
    );
  }

  static void showWarning(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    showSnackBar(
      context: context,
      message: message,
      type: SnackBarType.warning,
      duration: duration ?? const Duration(seconds: 4),
    );
  }

  static void showInfo(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    showSnackBar(
      context: context,
      message: message,
      type: SnackBarType.info,
      duration: duration ?? const Duration(seconds: 3),
    );
  }
}
