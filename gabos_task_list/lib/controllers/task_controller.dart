import 'package:gabos_task_list/model/model.dart';
import 'package:get/get.dart';

class TaskController extends GetxController{
  List<Task> tasks = <Task>[].obs;

  Future<List<Task>> getTasks(int personId) async {
    tasks = await Task().select().personId.equals(personId).orderBy(['isCompleted', 'dueDate']).toList();
    return tasks;
  }


}