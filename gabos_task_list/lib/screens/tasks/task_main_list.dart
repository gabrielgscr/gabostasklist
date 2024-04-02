import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gabos_task_list/controllers/global_values_controller.dart';
import 'package:gabos_task_list/controllers/task_controller.dart';
import 'package:gabos_task_list/model/model.dart';
import 'package:gabos_task_list/widgets/input_wrapper.dart';
import 'package:gabos_task_list/widgets/task_list_view.dart';
import 'package:gabos_task_list/widgets/theme.dart';
import 'package:get/get.dart';

class TaskMainList extends StatelessWidget {
  const TaskMainList({Key? key}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return Container(
    width: double.infinity,
    height: double.infinity,
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/desktop.jpg'), // Cambia esto a la ruta de tu imagen.
        fit: BoxFit.cover,
      ),
    ),
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
    return SingleChildScrollView(
      child: FutureBuilder(
      future: tasks.getTasks(global.personId.value),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }else if (snapshot.data!.isEmpty) {
          return const Center(child: Text('Ingresa más tareas'));
         } else {
          List<Task> tasks = snapshot.data!;
          return TaskListView(tasks: tasks, tasksColor: notesColor!, canScroll: false,);
        }
      },
            ),
    );
  }

  Widget _createFilter() {
    var tasks = Get.put(TaskController());
    var global = Get.find<GlobalValuesController>();
    return Container(
      padding: defaultPadding,
      color: backgroundAccentColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: InputWrapper(
              fillColor: backgroundAccentColor,
              padding: 5,
              child: TextField(
                  controller: _filterController,
                  decoration: const InputDecoration(
                    labelText: 'Filtrar tareas',
                    prefixIcon: Icon(Icons.search),
                  ),
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
    return Container(
      padding: defaultPadding,
      color: backgroundAccentColor,
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
        defaultVSpace,
        Expanded(child: SingleChildScrollView(child: _createTaskList())),
      ],
    ));
  }
}

