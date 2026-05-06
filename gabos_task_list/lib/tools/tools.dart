import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum AppSnackbarType { success, error, info }

void showSnackbar(
  String message, {
  AppSnackbarType type = AppSnackbarType.info,
}) {
  IconData iconData = Icons.info_outline;
  Color backgroundColor = Colors.blue.shade700;

  switch (type) {
    case AppSnackbarType.success:
      iconData = Icons.check_circle_outline;
      backgroundColor = Colors.green.shade700;
      break;
    case AppSnackbarType.error:
      iconData = Icons.error_outline;
      backgroundColor = Colors.red.shade700;
      break;
    case AppSnackbarType.info:
      break;
  }

  final context = Get.context;

  if (context != null) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger != null) {
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          showCloseIcon: true,
          closeIconColor: Colors.white,
          content: Text(message),
          duration: const Duration(seconds: 4),
        ),
      );
      return;
    }
  }

  Get.snackbar(
    "Task List",
    message,
    icon: Icon(iconData, color: Colors.white),
    duration: const Duration(seconds: 5),
    isDismissible: true,
    backgroundColor: backgroundColor,
    colorText: Colors.white,
    dismissDirection: DismissDirection.startToEnd,
  );
}
