import 'package:get/get.dart';

class GlobalValuesController extends GetxController {
  var _username = ''.obs;
  var loading = false.obs;
  
  var personId = 0.obs;

  String get username => _username.value;

  set username(String username) => _username.value = username;

  void clear() {
    _username.value = '';
  }
}
