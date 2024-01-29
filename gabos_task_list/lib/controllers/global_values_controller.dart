import 'package:get/get.dart';

class GlobalValuesController extends GetxController {
  var _username = ''.obs;
  var loading = false.obs;

  String get username => _username.value;

  void setUsername(String username) => _username.value = username;

  void clear() {
    _username.value = '';
  }
}
