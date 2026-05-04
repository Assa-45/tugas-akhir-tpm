import 'package:hive/hive.dart';

class StorageService {
  static const _boxName = 'authBox';

  static Future<Box> _box() async {
    return await Hive.openBox(_boxName);
  }

  static Future<void> saveUser({
    required String email,
    required String passwordHash,
    required String name,  
  }) async {
    final box = await _box();
    await box.put('email', email);
    await box.put('password', passwordHash);
    await box.put('name', name);
    await box.put('isRegistered', true);
  }

  static Future<void> setBiometricEnabled(bool value) async {
    final box = await _box();
    await box.put('biometric', value);
  }

  static Future<bool> isBiometricEnabled() async {
    final box = await _box();
    return box.get('biometric', defaultValue: false);
  }

  static Future<bool> isRegistered() async {
    final box = await _box();
    return box.get('isRegistered', defaultValue: false);
  }

  static Future<String?> getEmail() async {
    final box = await _box();
    return box.get('email');
  }

  static Future<String?> getPassword() async {
    final box = await _box();
    return box.get('password');
  }

  static Future<String?> getName() async {
    final box = await _box();
    return box.get('name');
  }
}