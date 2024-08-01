import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:local_auth/local_auth.dart';

import 'AuthData.dart';
import 'ThemeStyle.dart';

class LocalAuth {
  static final _auth = LocalAuthentication();

  static Future<bool> _canAuthenticate() async =>
      await _auth.canCheckBiometrics || await _auth.isDeviceSupported();

  static Future<bool> authenticate(BuildContext context) async {
    try {
      if (!await _canAuthenticate()) return false;

      bool biometricSuccess = await _auth.authenticate(
        localizedReason: "Use fingerprint",
      );


      if (biometricSuccess ) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Center(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SpinKitWave(
                      color: Colors.orange,
                      size: 50.0,
                    ),
                    SizedBox(height: 0),
                    Text(
                      'Authenticating...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            );
          },

        );


        String status = await AuthData.userBiometricAuthenticate(
          username: AuthData.biousername,
          pin: AuthData.biopin,
          context: context,
          useBiometric: true,
        );

        await AuthData.saveLoginStatus(true);

        if (status == 'failure') {
          Navigator.pop(context);
        }

        return status == 'success';
      } else {
        debugPrint('Biometric authentication failed or canceled');
        return false;
      }
    } catch (e) {
      debugPrint('Error during biometric authentication: $e');
      return false;
    }
  }
}
