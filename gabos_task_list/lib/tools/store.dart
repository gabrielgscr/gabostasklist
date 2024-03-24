import 'package:gabos_task_list/model/user_info.dart';
import 'package:gabos_task_list/tools/password_encryption.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> storeValue(String key, String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

// Método para recuperar un valor de SharedPreferences
Future<String?> getValue(String key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey(key)) {
    return prefs.getString(key);
  } else {
    return "";
  }
}

Future<bool> containsData(String key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.containsKey(key);
}

Future<void> storeUserInfo(UserInfo info) async {
  await storeValue("uname", info.name);
  await storeValue("key", PasswordEncryption.encryptPassword(info.password));
}

Future<void> removeUserInfo() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove("uname");
  prefs.remove("key");
}

Future<UserInfo> getUserInfo() async {
  var info = UserInfo();
  info.name = (await getValue("uname"))!;
  String password = (await getValue("key"))!;
  if (password.isNotEmpty) {
    info.password = PasswordEncryption.decryptPassword(password);
  } else {
    info.password = "";
  }
  return info;
}
