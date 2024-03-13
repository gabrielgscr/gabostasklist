import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:gabos_task_list/model/model.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class DashboardController extends GetxController {
  List<Task> todayTasks = <Task>[].obs;
  List<Task> tomorrowTasks = <Task>[].obs;
  List<Task> dueTasks = <Task>[].obs;
  var todayExpanded = true.obs;
  var tomorrowExpanded = false.obs;
  var dueExpanded = false.obs;

  Future<List<Task>> getTodayTasks(int personId) async {
    tz.initializeTimeZones();
    final currentTimezone = getCurrentTimezone();
    var location = tz.getLocation(await currentTimezone);
    var now = tz.TZDateTime.now(location);
    var offset = now.timeZoneOffset.inHours;
    //var offset = -6;
    todayTasks = await Task().select().where("personId = ? AND date(datetime(dueDate / 1000, 'unixepoch', '${offset > 0 ? '+' : ''}$offset hours'))  = date(CURRENT_DATE)", 
    parameterValue: [personId]).toList();
    return todayTasks;
  }

  Future<List<Task>> getTomorrowTasks(int personId) async {
    final currentTimezone = getCurrentTimezone();
    var location = tz.getLocation(await currentTimezone);
    var now = tz.TZDateTime.now(location);
    var offset = now.timeZoneOffset.inHours;
    //var offset = -6;
    tomorrowTasks = await Task().select().where("personId = ? AND date(datetime(dueDate / 1000, 'unixepoch', '${offset > 0 ? '+' : ''}$offset hours'))  = date(CURRENT_DATE, '+1 day')", 
    parameterValue: [personId]).toList();
    return tomorrowTasks;
  }

  Future<List<Task>> getDueTasks(int personId) async {
    tz.initializeTimeZones();
    final currentTimezone = getCurrentTimezone();
    var location = tz.getLocation(await currentTimezone);
    var now = tz.TZDateTime.now(location);
    var offset = now.timeZoneOffset.inHours;
    //var offset = -6;
    dueTasks = await Task().select().where("personId = ? AND isCompleted = 0 AND date(datetime(dueDate / 1000, 'unixepoch', '${offset > 0 ? '+' : ''}$offset hours'))  < date(CURRENT_DATE)", 
    parameterValue: [personId]).toList();
    return dueTasks;
  }

  Future<String> getCurrentTimezone() async{
    final currentTimezone = await FlutterTimezone.getLocalTimezone();
    return currentTimezone;
  }
  void swapTodayExpanded() {
      todayExpanded.value = !todayExpanded.value;
  }

  void swapTomorrowExpanded() {
      tomorrowExpanded.value = !tomorrowExpanded.value;
  }

  void swapDueExpanded() {
      dueExpanded.value = !dueExpanded.value;
  }

}