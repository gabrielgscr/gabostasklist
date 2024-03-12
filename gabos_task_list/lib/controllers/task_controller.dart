import 'package:gabos_task_list/model/model.dart';
import 'package:get/get.dart';

class TaskController extends GetxController{
  List<Task> tasks = <Task>[].obs;
  var showCompleted = false.obs;
  var filter = ''.obs;

  Future<List<Task>> getTasks(int personId) async {
    if (filter.value.isEmpty) {
      if (showCompleted.value) {
        tasks = await Task().select().personId.equals(personId).orderBy(['isCompleted', 'dueDate']).toList();
      } else {
        tasks = await Task().select().personId.equals(personId).and.isCompleted.equals(false).orderBy(['isCompleted', 'dueDate']).toList();
      }
    } else {
      tasks = await Task().select().where("personId = ? ${!showCompleted.value ? 'AND isCompleted = false' : ''}  AND (title LIKE ? OR description LIKE ?)", parameterValue: [personId, '%${filter.value}%', '%${filter.value}%']).orderBy(['isCompleted', 'dueDate']).toList();
    }
    
    //tasks = await Task().select().personId.equals(personId).orderBy(['isCompleted', 'dueDate']).toList();
    return tasks;
  }

}