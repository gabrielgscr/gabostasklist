import 'package:gabos_task_list/model/generic_response.dart';
import 'package:gabos_task_list/model/model.dart';
import 'package:gabos_task_list/tools/local_notifications_helper.dart';
import 'package:get/get.dart';

class NewTaskController extends GetxController{
  var description = ''.obs;
  var dueDate = DateTime.now().obs;
  var title = ''.obs;
  var enabledHours = true.obs;
  var reminderCode = 0.obs;

  Future<GenericResponse> createNewTask(int personId) async {
    try {
      Task newTask = Task(
        title: title.value,
        description: description.value,
        dueDate: dueDate.value,
        allDayTask: !enabledHours.value,
        createdDate: DateTime.now(),
        updatedDate: DateTime.now(),
        personId: personId
      );
      var result = await newTask.save();
      if(reminderCode.value > 0){
        var response = await createNewReminder(newTask.id!);
        if(response.responseCode == 0){
          bool scheduleResult = await _scheduleReminder(response.responseObject as Reminder);
          print("Se canlendarizó el recordatorio: $scheduleResult");
        }
      }
      return GenericResponse(
        result! > 0 ? 0 : -1,
        result > 0 ? 'Tarea creada' : 'Error al crear la tarea',
        responseObject: newTask
      );
    } catch (e) {
      return GenericResponse(-2, 'Excepción al crear la tarea');
    }
  }

   Future<GenericResponse> createNewReminder(int taskId) async {
    try {
      Reminder newReminder = Reminder(
        reminderDate: dueDate.value,
        reminderType: reminderCode.value,
        createdDate: DateTime.now(),
        updatedDate: DateTime.now(),
        taskId: taskId
      );
      var result = await newReminder.save();
      return GenericResponse(
        result! > 0 ? 0 : -1,
        result > 0 ? 'Recordatorio creado' : 'Error al crear el recordatorio',
        responseObject: newReminder
      );
    } catch (e) {
      return GenericResponse(-2, 'Excepción al crear el recordatorio');
    }
  }

  Future<bool> _scheduleReminder(Reminder reminder) async {
    return await LocalNotificationHelper.scheduleLocalNotification(
      id: reminder.id!,
      dateTime: getReminder(),
      title: title.value,
      body: description.value,
      data: reminder.id.toString()
    );
  }

  DateTime getReminder(){
    DateTime fecha = dueDate.value;
    switch(reminderCode.value){
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