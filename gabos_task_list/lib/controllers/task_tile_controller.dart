import 'package:get/get.dart';

class TaskTileController extends GetxController {
  var isCompleted = false.obs;

  void toggleIsCompleted() {
    isCompleted.value = !isCompleted.value;
  }

}
