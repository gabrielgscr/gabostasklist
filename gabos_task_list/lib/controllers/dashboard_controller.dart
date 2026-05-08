import 'package:gabos_task_list/model/model.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  List<Task> todayTasks = <Task>[].obs;
  List<Task> tomorrowTasks = <Task>[].obs;
  List<Task> dueTasks = <Task>[].obs;
  var todayExpanded = true.obs;
  var tomorrowExpanded = false.obs;
  var dueExpanded = false.obs;
  var reloadKey = 0.obs;

  void notifyDataChanged() {
    reloadKey.value++;
  }

  int _currentOffsetHours() {
    return DateTime.now().timeZoneOffset.inHours;
  }

  Future<List<Task>> getTodayTasks(int personId) async {
    final offset = _currentOffsetHours();
    todayTasks = await Task()
        .select()
        .where(
          "personId = ? AND date(datetime(dueDate / 1000, 'unixepoch', '${offset > 0 ? '+' : ''}$offset hours'))  = date(datetime('now'), '${offset > 0 ? '+' : ''}$offset hours')",
          parameterValue: [personId],
        )
        .toList();
    return todayTasks;
  }

  Future<List<Task>> getTomorrowTasks(int personId) async {
    final offset = _currentOffsetHours();
    tomorrowTasks = await Task()
        .select()
        .where(
          "personId = ? AND date(datetime(dueDate / 1000, 'unixepoch', '${offset > 0 ? '+' : ''}$offset hours'))  = date(datetime(datetime('now'), '${offset > 0 ? '+' : ''}$offset hours'), '+1 day')",
          parameterValue: [personId],
        )
        .toList();
    return tomorrowTasks;
  }

  Future<List<Task>> getDueTasks(int personId) async {
    final offset = _currentOffsetHours();
    dueTasks = await Task()
        .select()
        .where(
          "personId = ? AND isCompleted = 0 AND datetime(dueDate / 1000, 'unixepoch', '${offset > 0 ? '+' : ''}$offset hours')  < datetime(datetime('now'), '${offset > 0 ? '+' : ''}$offset hours')",
          parameterValue: [personId],
        )
        .toList();
    return dueTasks;
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
