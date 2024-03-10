import 'package:flutter/material.dart';
import 'package:gabos_task_list/screens/login/login_screen.dart';
import 'package:gabos_task_list/screens/dashboard/welcome_screen.dart';

Map<String, WidgetBuilder> routes = {
  'login': (_) => const LoginScreen(),
  'welcome': (_) => const WelcomeScreen(),
};
