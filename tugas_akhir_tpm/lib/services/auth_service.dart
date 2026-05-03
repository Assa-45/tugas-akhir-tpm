import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'storage_service.dart';

class AuthService {
  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  static Future<bool> login(String email, String password) async {
    final savedEmail = await StorageService.getEmail();
    final savedPass = await StorageService.getPassword();

    if (savedEmail == email &&
        savedPass == hashPassword(password)) {
      return true;
    }
    return false;
  }
}