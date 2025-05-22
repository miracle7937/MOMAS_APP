

import 'dart:developer';

import 'package:local_auth/local_auth.dart';

class BioMetric{
  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<bool> authenticate() async {
    bool isAuthenticated = false;
    try {
      isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to perform this action',
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      );
    } on Exception catch (e) {
      log(e.toString());
    }

    return isAuthenticated;
  }

  Future<bool> isBiometricAvailable() async {
    try {
      bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      bool isBiometricSupported = await _localAuth.isDeviceSupported();
      List<BiometricType> availableBiometrics = await _localAuth.getAvailableBiometrics();

      return canCheckBiometrics && isBiometricSupported && availableBiometrics.isNotEmpty;
    } on Exception catch (e) {
      log(e.toString());
      return false;
    }
  }
}