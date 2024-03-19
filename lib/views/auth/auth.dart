import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:medicare/views/home.dart';

import '../../utils/shared.dart';

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
        print(availableBiometrics);
        auth.authenticate(localizedReason: "localizedReason").then(
          (bool value) {
            if (value) {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const Home()));
            }
          },
        );
        // Some biometrics are enrolled.
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
            Text("Biometrics", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: blueColor)),
            const SizedBox(height: 20),
            GestureDetector(onTap: _onPressed, child: LottieBuilder.asset("assets/lotties/fingerprint.json", fit: BoxFit.contain)),
          ],
        ),
      ),
    );
  }
}
