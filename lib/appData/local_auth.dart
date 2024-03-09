import 'package:flutter/widgets.dart';
import 'package:local_auth/local_auth.dart';

import 'AuthData.dart';
class LocalAuth {
  static final _auth = LocalAuthentication();

  static Future<bool> _canAuthenticate() async =>
      await _auth.canCheckBiometrics || await _auth.isDeviceSupported();

  static Future<bool> authenticate(BuildContext context) async {
    try {
      if (!await _canAuthenticate()) return false;

      // Biometric authentication
      bool biometricSuccess = await _auth.authenticate(
        localizedReason: "Use fingerprint",
      );

      if (biometricSuccess) {
        // If biometric authentication is successful, call userBiometricAuthenticate
        await AuthData.userBiometricAuthenticate(
          username: '03222486053',
          pin: '1111', // Use a predefined or temporary pin for biometric authentication
          context: context,
          useBiometric: true,
        );

      } else {

        debugPrint('Biometric authentication failed or canceled');
      }

      return biometricSuccess;
    } catch (e) {
      debugPrint('Error during biometric authentication: $e');
      return false;
    }
  }
}
