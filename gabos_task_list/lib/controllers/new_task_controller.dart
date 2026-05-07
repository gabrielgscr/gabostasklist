import 'package:flutter/material.dart';
import 'package:gabos_task_list/model/generic_response.dart';
import 'package:gabos_task_list/model/model.dart';
import 'package:gabos_task_list/tools/local_notifications_helper.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NewTaskController extends GetxController {
  NewTaskController({this.task});

  final Task? task;

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  var description = ''.obs;
  var dueDate = DateTime.now().obs;
  var title = ''.obs;
  var enabledHours = true.obs;
  var reminderCode = 0.obs;
  var isLoading = true.obs;
  final editingTask = Rxn<Task>();
  final editingReminder = Rxn<Reminder>();

  bool get isEditMode => editingTask.value != null;

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    timeController.dispose();
    super.onClose();
  }

  Future<void> _initialize() async {
    isLoading.value = true;
    editingTask.value = task;
    editingReminder.value = null;

    final now = DateTime.now();

    if (task == null) {
      title.value = '';
      description.value = '';
      dueDate.value = now;
      enabledHours.value = true;
      reminderCode.value = 0;
    } else {
      title.value = task!.title ?? '';
      description.value = task!.description ?? '';
      dueDate.value = task!.dueDate ?? now;
      enabledHours.value = !(task!.allDayTask ?? false);

      final reminders = await Reminder()
          .select()
          .taskId
          .equals(task!.id)
          .toList();
      if (reminders.isNotEmpty) {
        final reminder = reminders.first;
        editingReminder.value = reminder;
        reminderCode.value = reminder.reminderType ?? 0;
      } else {
        reminderCode.value = 0;
      }
    }

    titleController.text = title.value;
    descriptionController.text = description.value;
    dateController.text = DateFormat('yyyy-MM-dd').format(dueDate.value);
    timeController.text = DateFormat('HH:mm').format(dueDate.value);

    isLoading.value = false;
  }

  Future<GenericResponse> saveTask(int personId) async {
    if (isEditMode) {
      return updateTask();
    }
    return createNewTask(personId);
  }

  Future<GenericResponse> createNewTask(int personId) async {
    try {
      final newTask = Task(
        title: title.value,
        description: description.value,
        dueDate: dueDate.value,
        allDayTask: !enabledHours.value,
        createdDate: DateTime.now(),
        updatedDate: DateTime.now(),
        personId: personId,
      );
      final result = await newTask.save();

      if (result == null || result <= 0) {
        return GenericResponse(-1, 'Error al crear la tarea');
      }

      final reminderResponse = await _replaceReminderForTask(newTask.id!);
      String message = 'Tarea creada';

      if (reminderResponse.responseCode < 0) {
        message = 'Tarea creada, pero no se pudo guardar el recordatorio';
      } else if (reminderResponse.responseCode == 1) {
        message = 'Tarea creada, pero no se pudo calendarizar el recordatorio';
      }

      return GenericResponse(0, message, responseObject: newTask);
    } catch (_) {
      return GenericResponse(-2, 'Excepción al crear la tarea');
    }
  }

  Future<GenericResponse> updateTask() async {
    final task = editingTask.value;
    if (task == null) {
      return GenericResponse(-1, 'No hay tarea para editar');
    }

    try {
      task.title = title.value;
      task.description = description.value;
      task.dueDate = dueDate.value;
      task.allDayTask = !enabledHours.value;
      task.updatedDate = DateTime.now();

      final result = await task.save();
      if (result == null || result <= 0) {
        return GenericResponse(-1, 'Error al actualizar la tarea');
      }

      final reminderResponse = await _replaceReminderForTask(task.id!);
      String message = 'Tarea actualizada';

      if (reminderResponse.responseCode < 0) {
        message = 'Tarea actualizada, pero no se pudo guardar el recordatorio';
      } else if (reminderResponse.responseCode == 1) {
        message =
            'Tarea actualizada, pero no se pudo calendarizar el recordatorio';
      }

      return GenericResponse(0, message, responseObject: task);
    } catch (_) {
      return GenericResponse(-2, 'Excepción al actualizar la tarea');
    }
  }

  Future<GenericResponse> _replaceReminderForTask(int taskId) async {
    try {
      final existingReminders = await Reminder()
          .select()
          .taskId
          .equals(taskId)
          .toList();

      for (final reminder in existingReminders) {
        final reminderId = reminder.id;
        if (reminderId != null) {
          await LocalNotificationHelper.cancelLocalNotification(reminderId);
        }
        await reminder.delete();
      }

      if (reminderCode.value <= 0) {
        editingReminder.value = null;
        return GenericResponse(0, 'Sin recordatorio');
      }

      final createReminderResponse = await createNewReminder(taskId);
      if (createReminderResponse.responseCode != 0) {
        return createReminderResponse;
      }

      final reminder = createReminderResponse.responseObject as Reminder;
      final scheduleResult = await _scheduleReminder(reminder);
      debugPrint('Se calendarizo el recordatorio: $scheduleResult');
      editingReminder.value = reminder;

      return GenericResponse(
        scheduleResult ? 0 : 1,
        scheduleResult
            ? 'Recordatorio actualizado'
            : 'No se pudo calendarizar el recordatorio',
        responseObject: reminder,
      );
    } catch (_) {
      return GenericResponse(-2, 'Excepción al procesar el recordatorio');
    }
  }

  Future<GenericResponse> createNewReminder(int taskId) async {
    try {
      final newReminder = Reminder(
        reminderDate: dueDate.value,
        reminderType: reminderCode.value,
        createdDate: DateTime.now(),
        updatedDate: DateTime.now(),
        taskId: taskId,
      );
      final result = await newReminder.save();
      return GenericResponse(
        result! > 0 ? 0 : -1,
        result > 0 ? 'Recordatorio creado' : 'Error al crear el recordatorio',
        responseObject: newReminder,
      );
    } catch (_) {
      return GenericResponse(-2, 'Excepción al crear el recordatorio');
    }
  }

  Future<bool> _scheduleReminder(Reminder reminder) async {
    return LocalNotificationHelper.scheduleLocalNotification(
      id: reminder.id!,
      dateTime: getReminder(),
      title: title.value,
      body: description.value,
      data: reminder.id.toString(),
    );
  }

  DateTime getReminder() {
    var fecha = dueDate.value;
    switch (reminderCode.value) {
      case 1:
        fecha = fecha.subtract(const Duration(minutes: 15));
        break;
      case 2:
        fecha = fecha.subtract(const Duration(minutes: 30));
        break;
      case 3:
        fecha = fecha.subtract(const Duration(hours: 1));
        break;
      case 4:
        fecha = fecha.subtract(const Duration(days: 1));
        break;
      case 5:
        fecha = fecha.subtract(const Duration(days: 7));
        break;
    }
    return fecha;
  }
}
