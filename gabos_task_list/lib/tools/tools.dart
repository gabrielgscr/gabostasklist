import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

showSnackbar(String message) {
  // final snackBar = SnackBar(content: Text(message));
  // ScaffoldMessenger.of(context).showSnackBar(snackBar);
  Get.snackbar("Task List", message,
      icon: const Icon(Icons.notifications),
      duration: const Duration(seconds: 5),
      isDismissible: true,
      backgroundColor: Colors.white,
      dismissDirection: DismissDirection.startToEnd);
}


