// ignore_for_file: prefer_final_fields

import 'package:gabos_task_list/model/generic_response.dart';
import 'package:gabos_task_list/tools/password_encryption.dart';
import 'package:get/get.dart';
//importar el modelo de bd
import 'package:gabos_task_list/model/model.dart';

class RegisterController extends GetxController {
  var _email = ''.obs;
  var _password = ''.obs;
  var _passwordConfirm = ''.obs;
  var _name = ''.obs;
  var _lastname = ''.obs;
  var loading = false.obs;

  String get email => _email.value;
  String get password => _password.value;
  String get passwordConfirm => _passwordConfirm.value;
  String get name => _name.value;
  String get lastname => _lastname.value;

  set email(String value) => _email.value = value;
  set password(String value) => _password.value = value;
  set passwordConfirm(String value) => _passwordConfirm.value = value;
  set name(String value) => _name.value = value;
  set lastname(String value) => _lastname.value = value;

  void clear() {
    _email.value = '';
    _password.value = '';
    _passwordConfirm.value = '';
    _name.value = '';
    _lastname.value = '';
  }

  Future<GenericResponse> createUser() async {
    if (password != passwordConfirm) {
      return GenericResponse(-1, 'Las contraseñas no coinciden');
    }
    Person person = Person(
        firstName: name,
        lastName: lastname,
        email: email,
        password: PasswordEncryption().encryptPassword(password),
        createdDate: DateTime.now(),
        updatedDate: DateTime.now());
    int? response = await person.save();
    if (response! <= 0) {
      return GenericResponse(-1, 'Error al crear el usuario');
    }
    return GenericResponse(1, 'Usuario creado correctamente');
  }
}
