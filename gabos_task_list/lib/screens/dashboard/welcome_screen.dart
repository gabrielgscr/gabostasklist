import 'package:flutter/material.dart';
import 'package:gabos_task_list/controllers/dashboard_controller.dart';
import 'package:gabos_task_list/controllers/global_values_controller.dart';
import 'package:gabos_task_list/controllers/task_controller.dart';
import 'package:gabos_task_list/controllers/welcome_controller.dart';
import 'package:gabos_task_list/screens/dashboard/dashboard.dart';
import 'package:gabos_task_list/screens/login/login_screen.dart';
import 'package:gabos_task_list/screens/profile/profile_screen.dart';
import 'package:gabos_task_list/screens/tasks/new_task_form.dart';
import 'package:gabos_task_list/screens/tasks/task_main_list.dart';
import 'package:gabos_task_list/widgets/custom_app_bar.dart';
import 'package:gabos_task_list/widgets/theme.dart';
import 'package:get/get.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  CustomAppBar _appBar() {
    GlobalValuesController c = Get.find<GlobalValuesController>();
    return CustomAppBar(
      title: "Tareas épicas",
      actions: [
        // Add a task button to the app bar
        IconButton(
          onPressed: () async {
            final result = await Get.to(() => NewTasKForm());
            if (result == true) {
              if (Get.isRegistered<TaskController>()) {
                Get.find<TaskController>().notifyDataChanged();
              }
              if (Get.isRegistered<DashboardController>()) {
                Get.find<DashboardController>().notifyDataChanged();
              }
            }
          },
          icon: const Icon(Icons.add),
        ),
        // Add a logout button to the app bar
        IconButton(
          onPressed: () {
            c.clear();
            Get.off(() => const LoginScreen());
          },
          icon: const Icon(Icons.exit_to_app),
        ),
        // Menu de opciones adicionales
        _menuButton(),
      ],
    );
  }

  PopupMenuButton<String> _menuButton() {
    return PopupMenuButton<String>(
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'notifications_debug',
          child: ListTile(
            leading: Icon(Icons.notifications_active),
            title: Text('Diagnóstico de Notificaciones'),
          ),
        ),
        PopupMenuItem(
          onTap: () => showAboutDialog(
            context: context,
            applicationName: 'Tareas épicas',
            applicationVersion: '1.0.0',
            applicationIcon: const Image(
              image: AssetImage('assets/pulpo.png'),
              width: 50,
              height: 50,
            ),
            children: const [
              Text('Desarrollado por TicoDevs'),
              Text('Versión 1.0.0'),
            ],
          ),
          value: 'about',
          child: const ListTile(
            leading: Icon(Icons.info),
            title: Text('Acerca de'),
          ),
        ),
      ],
      onSelected: (value) {
        if (value == 'notifications_debug') {
          Get.toNamed('/notifications_debug');
        } else if (value == 'about') {
          // Navigate to the about screen
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    WelcomeController c = Get.put(WelcomeController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      c.setPage = c.currentPage.value;
    });
    return Scaffold(
      appBar: _appBar(),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: c.pageController,
        children: const [Dashboard(), TaskMainList(), ProfileScreen()],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    WelcomeController c = Get.find();
    return Obx(
      () => BottomNavigationBar(
        currentIndex: c.currentPage.value,
        selectedItemColor: strongBlue,
        onTap: (index) {
          c.currentPage.value = index;
          c.setPage = index;
        },
        backgroundColor: bottomNavigationBarBackgroundColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Tareas'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
