import 'package:flutter/material.dart';
import 'package:gabos_task_list/controllers/welcome_controller.dart';
import 'package:gabos_task_list/screens/tasks/new_task_form.dart';
import 'package:gabos_task_list/screens/tasks/task_main_list.dart';
import 'package:gabos_task_list/widgets/custom_app_bar.dart';
import 'package:gabos_task_list/widgets/theme.dart';
import 'package:get/get.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  CustomAppBar _appBar() {
    return CustomAppBar(
      title: "Gabo's Task List",
      actions: [
          // Add a task button to the app bar
          IconButton(
            onPressed: () {
              Get.to(NewTasKForm());
            },
            icon: const Icon(Icons.add),
          ),
          // Add a logout button to the app bar
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.exit_to_app),
          ),
          // Menu de opciones adicionales
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'settings',
                child: ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Opciones'),
                ),
              ),
              const PopupMenuItem(
                value: 'about',
                child: ListTile(
                  leading: Icon(Icons.info),
                  title: Text('Acerca de'),
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'settings') {
                // Navigate to the settings screen
              } else if (value == 'about') {
                // Navigate to the about screen
              }
            },
          ),
        ],
    );
  }

  @override
  Widget build(BuildContext context) {
    WelcomeController c = Get.put(WelcomeController());
    return Scaffold(
      appBar: _appBar(),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: c.pageController,
        children: const [
          TaskMainList()
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar()
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    WelcomeController c = Get.find();
    return Obx(() => BottomNavigationBar(
      currentIndex: c.currentPage.value,
      selectedItemColor: strongBlue,
      onTap: (index) {
        c.currentPage.value = index;
      },
      backgroundColor: bottomNavigationBarBackgroundColor,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Tareas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    ));
  }
}

