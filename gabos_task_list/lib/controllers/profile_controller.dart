import 'package:gabos_task_list/model/model.dart';
import 'package:gabos_task_list/tools/shared_preferences_helper.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  var editMode = false.obs;
  var remember = false.obs;

  Future<Person?> getPersonInformation(int personId) async {
    // Aquí va la lógica para obtener la información de la persona.
    var person = await Person().getById(personId);
    return person;
  }

  Future<bool> rememberIsChecked() async {
    bool? enabled = await SharedPreferencesHelper.getBool("remember");
    remember.value = enabled!;
    return enabled;
  }

  Future<void> setRemember(bool value) async {
    remember.value = value;
    await SharedPreferencesHelper.setBool("remember", value);
  }

}