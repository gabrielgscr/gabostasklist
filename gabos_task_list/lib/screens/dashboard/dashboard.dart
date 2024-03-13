import 'package:flutter/material.dart';
import 'package:gabos_task_list/controllers/dashboard_controller.dart';
import 'package:gabos_task_list/controllers/global_values_controller.dart';
import 'package:gabos_task_list/model/model.dart';
import 'package:gabos_task_list/widgets/notes_container.dart';
import 'package:gabos_task_list/widgets/task_panel_list.dart';
import 'package:gabos_task_list/widgets/theme.dart';
import 'package:get/get.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  Widget _displayTasks(Future<List<Task>> Function(int) getTasks, 
    void Function() swapFunction, bool isExpanded, 
    String title, {String? noDataTitle, Color? backgroundColor}){
    GlobalValuesController global = Get.find<GlobalValuesController>();
    return TaskPanelList(
      getTasks: getTasks, 
      swapFunction: swapFunction, 
      isExpanded: isExpanded, 
      title: title,
      getTasksParameter: global.personId.value,
      noDataTitle: noDataTitle ?? 'No hay tareas',
      backgroundColor: backgroundColor
    );
  }

  Widget _dashboardTitle() {
    return Padding(
            padding: defaultPadding,
            child: Container(
              padding: defaultPadding,
              width: double.infinity,
              // Borde
              decoration: BoxDecoration(
                color: notesColor,
                borderRadius: BorderRadius.circular(10), // Borde redondeado
                border: Border.all(
                  color: defaultColor,
                  width: 1,
                ),
              ),
              child: NotesContainer(
                child: Center(
                  child: Text(
                    'Tu trabajo cercano',
                    style: TextStyle(
                      fontSize: 20,
                      color: strongBlue,
                    ),
                  ),
                ),
              )
            ),
          );
  } 

  @override
  Widget build(BuildContext context) {
    DashboardController controller = Get.put(DashboardController());
    return Obx(() => Stack(
        children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset('assets/desktop.jpg', fit: BoxFit.cover),
            ),
            SingleChildScrollView(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _dashboardTitle(),
                _displayTasks(controller.getTodayTasks, 
                  controller.swapTodayExpanded, 
                  controller.todayExpanded.value,
                  'Tareas de hoy'
                ),
                _displayTasks(controller.getDueTasks, 
                  controller.swapDueExpanded, 
                  controller.dueExpanded.value,
                  'Tareas atrasadas',
                  noDataTitle: 'Felicidades no hay tareas atrasadas',
                  backgroundColor: lightRed
                ),
                _displayTasks(controller.getTomorrowTasks, 
                  controller.swapTomorrowExpanded, 
                  controller.tomorrowExpanded.value,
                  'Tareas de mañana',
                  backgroundColor: lightGreen,
                ),
              ],
                      ),
            ),
        ],
      )
    );
  }
} 

