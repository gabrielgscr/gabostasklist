import 'package:encrypt/encrypt.dart';

class PasswordEncryption {
  final String _encryptionKey = "tasklist+123vect";
  final String _iv = "tasklist+123vect";

  PasswordEncryption();

  String encryptPassword(String password) {
    final key = Key.fromUtf8(_encryptionKey);
    final iv = IV.fromUtf8(_iv);
    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encrypt(password, iv: iv);
    return encrypted.base64;
  }

  String decryptPassword(String encryptedPassword) {
    final key = Key.fromUtf8(_encryptionKey);
    final iv = IV.fromUtf8(_iv);
    final encrypter = Encrypter(AES(key));
    String decrypted =
        encrypter.decrypt(Encrypted.fromBase64(encryptedPassword), iv: iv);
    return decrypted;
  }
}
