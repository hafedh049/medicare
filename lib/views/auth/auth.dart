import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:medicare/views/home.dart';

class FingerPrint extends StatefulWidget {
  const FingerPrint({super.key});

  @override
  State<FingerPrint> createState() => _FingerPrintState();
}

class _FingerPrintState extends State<FingerPrint> {
  void _onPressed() async {
    final LocalAuthentication auth = LocalAuthentication();
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate = canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    if (canAuthenticate) {
      final List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();
      if (availableBiometrics.isNotEmpty) {
        auth.authenticate(localizedReason: "localizedReason").then(
          (bool value) {
            if (value) {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const Home()));
            }
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            LottieBuilder.asset("assets/lotties/welcome.json", fit: BoxFit.contain, reverse: true),
            GestureDetector(onTap: _onPressed, child: LottieBuilder.asset("assets/lotties/fingerprint.json", width: 100, height: 100, reverse: true)),
          ],
        ),
      ),
    );
  }
}
