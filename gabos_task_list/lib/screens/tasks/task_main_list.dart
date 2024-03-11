import 'package:flutter/material.dart';
import 'package:gabos_task_list/controllers/global_values_controller.dart';
import 'package:gabos_task_list/controllers/task_controller.dart';
import 'package:gabos_task_list/model/model.dart';
import 'package:gabos_task_list/widgets/task_tile.dart';
import 'package:gabos_task_list/widgets/theme.dart';
import 'package:get/get.dart';

class TaskMainList extends StatelessWidget {
  const TaskMainList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: FilteredTaskList(),
    );
  }
}

class FilteredTaskList extends StatelessWidget {
  const FilteredTaskList({super.key});

  Widget _createTaskList() {
    var tasks = Get.put(TaskController());
    var global = Get.find<GlobalValuesController>();
    return FutureBuilder(
      future: tasks.getTasks(global.personId.value),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }else if (snapshot.data!.isEmpty) {
          return const Center(child: Text('Ingresa más tareas'));
         } else {
          List<Task> tasks = snapshot.data!;
          return Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                return TaskTile(
                  task: tasks[index],
                );
              },
              separatorBuilder: (context, index) => Divider(
                thickness: 1.5,
                color: defaultColor,
              ),
              itemCount: snapshot.data!.length,
              shrinkWrap: true,
              padding: const EdgeInsets.all(5),
            ),
          );
        }
      },
    );
  }

  Widget _createFilter() {
    return const Padding(
      padding: EdgeInsets.all(5.0),
      child: TextField(
        
          decoration: InputDecoration(
            labelText: 'Filtrar tareas',
            prefixIcon: Icon(Icons.search),
          ),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      children: [
        _createFilter(),
        _createTaskList(),
      ],
    ));
  }
}