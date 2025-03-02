import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:momas_pay/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricLoginWidget extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const BiometricLoginWidget({super.key, required this.onLoginSuccess});

  @override
  _BiometricLoginWidgetState createState() => _BiometricLoginWidgetState();
}

class _BiometricLoginWidgetState extends State<BiometricLoginWidget>
    with SingleTickerProviderStateMixin {
  final LocalAuthentication _auth = LocalAuthentication();
  bool _isBiometricAvailable = false;
  bool _isBiometricEnabled = false;
  bool _isAuthenticating = false;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  /// ✅ Check if the device supports biometrics
  Future<void> _checkBiometricAvailability() async {
    bool isDeviceSupported = await _auth.isDeviceSupported();
    bool canCheckBiometrics = await _auth.canCheckBiometrics;
    List<BiometricType> availableBiometrics =
        await _auth.getAvailableBiometrics();

    if (isDeviceSupported &&
        canCheckBiometrics &&
        availableBiometrics.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _isBiometricAvailable = true;
        _isBiometricEnabled = prefs.getBool('biometric_enabled') ?? false;
      });
    } else {
      setState(() {
        _isBiometricAvailable = false;
      });
    }
  }

  Future<void> _authenticate() async {
    if (!_isBiometricEnabled || _isAuthenticating) return;

    try {
      setState(() => _isAuthenticating = true);
      bool authenticated = await _auth.authenticate(
        localizedReason: 'Scan your fingerprint to log in',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (authenticated) {
        widget.onLoginSuccess();
      }
    } catch (e) {
      debugPrint('Authentication error: $e');
    } finally {
      setState(() => _isAuthenticating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Hide widget if biometrics are not available
    if (!_isBiometricAvailable || !_isBiometricEnabled) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: _authenticate,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: TweenAnimationBuilder(
          tween: ColorTween(
            begin: MoColors.mainColor,
            end: _isAuthenticating ? Colors.grey : MoColors.mainColor,
          ),
          duration: const Duration(milliseconds: 300),
          builder: (context, color, child) => Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: const Icon(
              Icons.fingerprint,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
