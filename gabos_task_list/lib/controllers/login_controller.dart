import 'package:gabos_task_list/model/generic_response.dart';
import 'package:gabos_task_list/model/model.dart';
import 'package:gabos_task_list/tools/password_encryption.dart';
import 'package:get/get.dart';

class LoginController extends RxController {
  var username = ''.obs;
  var password = ''.obs;

  Future<GenericResponse> login() async {
    if (username.value.isEmpty || password.value.isEmpty) {
      return GenericResponse(-1, 'Usuario y contraseña son requeridos');
    } else {
      Person? person =
          await Person().select().email.equals(username.value).toSingle();
      if (person == null) {
        return GenericResponse(-1, 'Usuario y/o contraseña incorrecta');
      } else {
        String cyphPass = PasswordEncryption().encryptPassword(password.value);
        if (person.password == cyphPass) {
          return GenericResponse(1, 'Usuario autenticado');
        } else {
          return GenericResponse(-1, 'Usuario y/o contraseña incorrecta');
        }
      }
    }
  }
}
