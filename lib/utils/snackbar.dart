import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum AppSnackType { success, error, warning, info }

class AppSnackbar {
  static void show({
    required String title,
    required String message,
    AppSnackType type = AppSnackType.info,
    SnackPosition position = SnackPosition.TOP,
  }) {
    final config = _SnackConfig.fromType(type);

    Get.snackbar(
      title,
      message,
      snackPosition: position,
      backgroundColor: config.backgroundColor,
      colorText: Colors.white,
      maxWidth: 400,
      icon: Icon(
        config.icon,
        color: Colors.white,
        size: 24,
      ),
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      borderRadius: 14,
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 300),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeIn,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.15),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }
}

/* ---------------------------------------------------------- */
/* ------------------ INTERNAL CONFIG ------------------------ */
/* ---------------------------------------------------------- */

class _SnackConfig {
  final Color backgroundColor;
  final IconData icon;

  _SnackConfig({
    required this.backgroundColor,
    required this.icon,
  });

  factory _SnackConfig.fromType(AppSnackType type) {
    switch (type) {
      case AppSnackType.success:
        return _SnackConfig(
          backgroundColor: const Color(0xFF38A169), // Green
          icon: Icons.check_circle_outline,
        );

      case AppSnackType.error:
        return _SnackConfig(
          backgroundColor: const Color(0xFFE53E3E), // Red
          icon: Icons.error_outline,
        );

      case AppSnackType.warning:
        return _SnackConfig(
          backgroundColor: const Color(0xFFDD6B20), // Orange
          icon: Icons.warning_amber_outlined,
        );

      case AppSnackType.info:
        return _SnackConfig(
          backgroundColor: const Color(0xFF3182CE), // Blue
          icon: Icons.info_outline,
        );
    }
  }
}
