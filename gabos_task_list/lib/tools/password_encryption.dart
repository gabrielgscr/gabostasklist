import 'package:encrypt/encrypt.dart';

class PasswordEncryption {
  static const String _encryptionKey = "tasklist+123vect";
  static const String _iv = "tasklist+123vect";

  PasswordEncryption();

  static String encryptPassword(String password) {
    final key = Key.fromUtf8(_encryptionKey);
    final iv = IV.fromUtf8(_iv);
    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encrypt(password, iv: iv);
    return encrypted.base64;
  }

  static String decryptPassword(String encryptedPassword) {
    final key = Key.fromUtf8(_encryptionKey);
    final iv = IV.fromUtf8(_iv);
    final encrypter = Encrypter(AES(key));
    String decrypted =
        encrypter.decrypt(Encrypted.fromBase64(encryptedPassword), iv: iv);
    return decrypted;
  }
}
