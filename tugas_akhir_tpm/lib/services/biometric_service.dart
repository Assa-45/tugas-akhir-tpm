import 'package:local_auth/local_auth.dart';

class BiometricService {
  static final _auth = LocalAuthentication();

  static Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Please put your fingerprint on sensor for verification',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true, 
        ),
      );
    } catch (e) {
      return false;
    }
  }
}