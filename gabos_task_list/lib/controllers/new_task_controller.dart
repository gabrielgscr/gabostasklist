import 'package:gabos_task_list/model/generic_response.dart';
import 'package:gabos_task_list/model/model.dart';
import 'package:get/get.dart';

class NewTaskController extends GetxController{
  var description = ''.obs;
  var dueDate = DateTime.now().obs;
  var title = ''.obs;
  var enabledHours = true.obs;

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
      return GenericResponse(
        result! > 0 ? 1 : -1,
        result > 0 ? 'Tarea creada' : 'Error al crear la tarea',
        responseObject: newTask
      );
    } catch (e) {
      return GenericResponse(-2, 'Excepción al crear la tarea');
    }
  }
}