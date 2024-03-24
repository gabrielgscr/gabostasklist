import 'package:gabos_task_list/model/generic_response.dart';
import 'package:gabos_task_list/model/model.dart';
import 'package:gabos_task_list/tools/password_encryption.dart';
import 'package:gabos_task_list/tools/shared_preferences_helper.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var username = ''.obs;
  var password = ''.obs;
  var remember = false.obs;

  Future<GenericResponse> login() async {
    if (username.value.isEmpty || password.value.isEmpty) {
      return GenericResponse(-1, 'Usuario y contraseña son requeridos');
    } else {
      Person? person =
          await Person().select().email.equals(username.value).toSingle();
      if (person == null) {
        return GenericResponse(-1, 'Usuario y/o contraseña incorrecta');
      } else {
        String cyphPass = PasswordEncryption.encryptPassword(password.value);
        if (person.password == cyphPass) {
          return GenericResponse(1, 'Usuario autenticado', responseObject: person);
        } else {
          return GenericResponse(-1, 'Usuario y/o contraseña incorrecta');
        }
      }
    }
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
