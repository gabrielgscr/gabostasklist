import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:gabos_task_list/model/generic_response.dart';
import 'package:gabos_task_list/model/model.dart';
import 'package:gabos_task_list/tools/constants.dart';
import 'package:gabos_task_list/tools/local_notifications_helper.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;

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
          await _scheduleReminder(response.responseObject as Reminder);
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

  Future<void> _scheduleReminder(Reminder reminder) async {

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // Paso 2: Configura los detalles de la notificación.
    var androidPlatformChannelSpecifics =  const AndroidNotificationDetails(
          remindersChannelId, 
          remindersChannelName, 
          channelDescription: channelDescription,
          importance: Importance.max, 
          priority: Priority.high, 
          showWhen: false
        );
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    String title = 'Recordatorio';
    String body = '$title - $description.value';
    //Calculo de la fecha de notificacion
    DateTime fecha = getReminder();
    tz.TZDateTime nowInLocal = tz.TZDateTime.from(fecha, tz.local);
    nowInLocal = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 30));
  
    // Paso 3: Programa la notificación.
    await flutterLocalNotificationsPlugin.zonedSchedule(
      reminder.id!,
      title,
      body,
      nowInLocal, // Cambia esto por la fecha y hora en que quieres que se muestre la notificación
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
    // LocalNotificationHelper.showLocalNotification(
    //   id: reminder.id!,
    //   title: title,
    //   body: body,
    //   data: reminder.id.toString()
    // );
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