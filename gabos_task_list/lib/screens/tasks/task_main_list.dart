import 'package:flutter/material.dart';
import 'package:gabos_task_list/controllers/global_values_controller.dart';
import 'package:gabos_task_list/controllers/task_controller.dart';
import 'package:gabos_task_list/model/model.dart';
import 'package:gabos_task_list/widgets/task_list_view.dart';
import 'package:gabos_task_list/widgets/theme.dart';
import 'package:get/get.dart';

class TaskMainList extends StatelessWidget {
  const TaskMainList({Key? key}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: FilteredTaskList(),
    );
  }
}

class FilteredTaskList extends StatelessWidget {
  FilteredTaskList({super.key});
  final _filterController = TextEditingController();
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
          return TaskListView(tasks: tasks);
        }
      },
    );
  }

  Widget _createFilter() {
    var tasks = Get.put(TaskController());
    var global = Get.find<GlobalValuesController>();
    return Padding(
      padding: defaultPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: TextField(
                controller: _filterController,
                decoration: const InputDecoration(
                  labelText: 'Filtrar tareas',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
          ),
            //Boton para filtrar
            IconButton(
              icon: const Icon(Icons.filter_alt),
              onPressed: () {
                tasks.filter.value = _filterController.text;
                if(_filterController.text.isEmpty) {
                  tasks.getTasks(global.personId.value);
                } else {
                  tasks.getTasks(global.personId.value);
                }
              },
            ),
            //Limpiar el filtro
            IconButton(
              icon: const Icon(Icons.filter_alt_off),
              onPressed: () {
                _filterController.clear();
                tasks.filter.value = '';
                tasks.getTasks(global.personId.value);
              },
            ),
        ],
      ),
    );
  }

  Widget _createShowCompleted() {
    return Padding(
      padding: defaultPadding,
      child: Row(
        children: [
          const Text('Mostrar completadas'),
          defaultVSpace,
          Obx(() => Switch(
            value: Get.find<TaskController>().showCompleted.value,
            onChanged: (value) {
              Get.find<TaskController>().showCompleted.value = value;
            },
            activeColor: activeTrackColor,
            activeTrackColor: strongBlue,
          )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      children: [
        _createFilter(),
        _createShowCompleted(),
        _createTaskList(),
      ],
    ));
  }
}

