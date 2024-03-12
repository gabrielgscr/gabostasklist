import 'package:flutter/material.dart';
import 'package:gabos_task_list/controllers/dashboard_controller.dart';
import 'package:gabos_task_list/controllers/global_values_controller.dart';
import 'package:gabos_task_list/model/model.dart';
import 'package:gabos_task_list/widgets/notes_container.dart';
import 'package:gabos_task_list/widgets/task_list_view.dart';
import 'package:gabos_task_list/widgets/theme.dart';
import 'package:get/get.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  Widget _displayTasks(Future<List<Task>> Function(int) getTasks, 
    void Function() swapFunction, bool isExpanded, String title){
    GlobalValuesController global = Get.find<GlobalValuesController>();
    return NotesContainer(
      child: ExpansionPanelList(

        expansionCallback: (int index, bool isExpanded) {
          swapFunction();
        },
        children: [
          ExpansionPanel(
            backgroundColor: notesColor,
            headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  
                  title: Text(title),
                );
              }, 
            body: FutureBuilder(
              future: getTasks(global.personId.value),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator()
                  );
                } else if (snapshot.data!.isEmpty) {
                  return const Center(child: Text('No hay tareas'));
                } else {
                  List<Task> tasks = snapshot.data!;
                  return TaskListView(tasks: tasks);
                }
              },
            ),
            isExpanded: isExpanded,
          ),
        ],
      ),
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
                    'Bienvenido a Gabo\'s Task List',
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
                _displayTasks(controller.getTomorrowTasks, 
                  controller.swapTomorrowExpanded, 
                  controller.tomorrowExpanded.value,
                  'Tareas de mañana'
                ),
                _displayTasks(controller.getDueTasks, 
                  controller.swapDueExpanded, 
                  controller.dueExpanded.value,
                  'Tareas atrasadas'
                )
              ],
                      ),
            ),
        ],
      )
    );
  }
} 

