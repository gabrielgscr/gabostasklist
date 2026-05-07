import 'package:flutter/material.dart';
import 'package:gabos_task_list/controllers/dashboard_controller.dart';
import 'package:gabos_task_list/controllers/new_task_controller.dart';
import 'package:gabos_task_list/controllers/task_controller.dart';
import 'package:gabos_task_list/controllers/task_tile_controller.dart';
import 'package:gabos_task_list/model/model.dart';
import 'package:gabos_task_list/screens/tasks/new_task_form.dart';
import 'package:gabos_task_list/widgets/task_date.dart';
import 'package:gabos_task_list/widgets/theme.dart';
import 'package:get/get.dart';

// Esta clase implementa un ListTile personalizado para mostrar una tarea.
class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.task,
    this.color = Colors.transparent,
  });

  final Task task;
  final Color color;

  Future<void> _confirmAndDeleteTask(
    BuildContext context,
    TaskTileController taskController,
  ) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar tarea'),
          content: const Text('¿Deseas eliminar esta tarea?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !context.mounted) {
      return;
    }

    await taskController.deleteTask(task);
  }

  Future<void> _openTaskDetail() async {
    // Eliminar controlador previo para garantizar instancia fresca en la nueva ruta
    Get.delete<NewTaskController>(force: true);
    final result = await Get.to(() => NewTasKForm(task: task));
    if (result == true) {
      if (Get.isRegistered<TaskController>()) {
        Get.find<TaskController>().notifyDataChanged();
      }
      if (Get.isRegistered<DashboardController>()) {
        Get.find<DashboardController>().notifyDataChanged();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    TaskTileController taskController = Get.put(
      TaskTileController(),
      tag: task.id.toString(),
    );
    taskController.isCompleted.value = task.isCompleted!;
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          border: Border.all(color: strongBlue, width: 1.0),
          borderRadius: defaultBorderRadius,
          color: color,
        ),
        child: Column(
          children: [
            ListTile(
              title: Text(
                task.title ?? '',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  decoration: task.isCompleted!
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
              subtitle: Text(task.description ?? ''),
              isThreeLine: true,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: taskController.isCompleted.value,
                    onChanged: (value) {
                      taskController.isCompleted.value = value!;
                      task.isCompleted = value;
                      task.save();
                    },
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) async {
                      if (value == 'delete') {
                        await _confirmAndDeleteTask(context, taskController);
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline),
                            SizedBox(width: 8),
                            Text('Eliminar tarea'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              leading: Icon(
                task.isCompleted! ? Icons.task : Icons.task_outlined,
                color: task.isCompleted! ? strongBlue : taskTodo,
              ),
              onTap: _openTaskDetail,
            ),
            defaultVSpace,
            TaskDate(task: task),
            _space(),
          ],
        ),
      ),
    );
  }

  SizedBox _space() => const SizedBox(height: 10.0);
}
