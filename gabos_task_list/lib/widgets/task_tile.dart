import 'package:flutter/material.dart';
import 'package:gabos_task_list/controllers/task_tile_controller.dart';
import 'package:gabos_task_list/model/model.dart';
import 'package:gabos_task_list/widgets/task_date.dart';
import 'package:gabos_task_list/widgets/theme.dart';
import 'package:get/get.dart';


// Esta clase implementa un ListTile personalizado para mostrar una tarea.
class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    TaskTileController taskController = Get.put(TaskTileController(), tag: task.id.toString());
    taskController.isCompleted.value = task.isCompleted!;
    return Obx(() => Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: strongBlue,
          width: 1.0,
        ),
        borderRadius: defaultBorderRadius,
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              task.title ?? '', 
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                decoration: task.isCompleted! ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Text(task.description ?? ''),
            isThreeLine: true,
            trailing: Checkbox(
              value: taskController.isCompleted.value,
              onChanged: (value) {
                taskController.isCompleted.value = value!;
                task.isCompleted = value;
                task.save();
              },
            ),
            leading: Icon(
              task.isCompleted! ? Icons.task : Icons.task_outlined,
              color: task.isCompleted! ? strongBlue : taskTodo,
            ),
            onTap: () {},
          ),
          defaultVSpace,
          TaskDate(task: task),
          _space(),
        ],
      ),
    ));
  }



  SizedBox _space() => const SizedBox(height: 10.0,);

}

