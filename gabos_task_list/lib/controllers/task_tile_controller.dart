import 'package:flutter/material.dart';
import 'package:gabos_task_list/controllers/dashboard_controller.dart';
import 'package:get/get.dart';
import 'package:gabos_task_list/controllers/task_controller.dart';
import 'package:gabos_task_list/model/model.dart';
import 'package:gabos_task_list/tools/local_notifications_helper.dart';
import 'package:gabos_task_list/tools/tools.dart';

class TaskTileController extends GetxController {
  var isCompleted = false.obs;

  void toggleIsCompleted() {
    isCompleted.value = !isCompleted.value;
  }

  void _notifyListChanged() {
    if (Get.isRegistered<TaskController>()) {
      Get.find<TaskController>().notifyDataChanged();
    }
    if (Get.isRegistered<DashboardController>()) {
      Get.find<DashboardController>().notifyDataChanged();
    }
  }

  Future<void> _showUndoSnackbar(Task task, List<Reminder> reminders) async {
    final context = Get.context;
    if (context == null || !context.mounted) {
      return;
    }

    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) {
      return;
    }

    messenger.hideCurrentSnackBar();
    final snackBarController = messenger.showSnackBar(
      SnackBar(
        content: const Text('Tarea eliminada'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 10),
        action: SnackBarAction(
          label: 'Deshacer',
          onPressed: () {
            _undoDelete(task, reminders);
          },
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 10), () {
      if (messenger.mounted) {
        snackBarController.close();
      }
    });
  }

  Future<void> _undoDelete(Task task, List<Reminder> reminders) async {
    try {
      final recoveredTask = await task.recover();
      if (!recoveredTask.success) {
        showSnackbar(
          'No se pudo recuperar la tarea',
          type: AppSnackbarType.error,
        );
        return;
      }

      for (final reminder in reminders) {
        final recoveredReminder = await reminder.recover();
        if (!recoveredReminder.success) {
          continue;
        }

        final reminderId = reminder.id;
        final reminderDate = reminder.reminderDate;
        if (reminderId == null || reminderDate == null) {
          continue;
        }

        await LocalNotificationHelper.scheduleLocalNotification(
          id: reminderId,
          dateTime: reminderDate,
          title: task.title,
          body: task.description,
          data: reminderId.toString(),
        );
      }

      _notifyListChanged();
      showSnackbar('Tarea recuperada', type: AppSnackbarType.success);
    } catch (_) {
      showSnackbar('Error al recuperar la tarea', type: AppSnackbarType.error);
    }
  }

  Future<bool> deleteTask(Task task) async {
    final taskId = task.id;
    if (taskId == null) {
      showSnackbar('No se pudo eliminar la tarea', type: AppSnackbarType.error);
      return false;
    }

    try {
      final reminders = await Reminder()
          .select()
          .taskId
          .equals(taskId)
          .toList();

      for (final reminder in reminders) {
        final reminderId = reminder.id;
        if (reminderId != null) {
          await LocalNotificationHelper.cancelLocalNotification(reminderId);
        }
        await reminder.delete();
      }

      final deleted = await task.delete();
      final deletedOk = deleted.success;

      if (deletedOk) {
        _notifyListChanged();
        await _showUndoSnackbar(task, reminders);
      } else {
        showSnackbar(
          'No se pudo eliminar la tarea',
          type: AppSnackbarType.error,
        );
      }

      return deletedOk;
    } catch (_) {
      showSnackbar('Error al eliminar la tarea', type: AppSnackbarType.error);
      return false;
    }
  }
}
