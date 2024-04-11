import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../utils/shared.dart';

class FingerPrint extends StatefulWidget {
  const FingerPrint({super.key});

  @override
  State<FingerPrint> createState() => SignIn();
}

class SignIn extends State<FingerPrint> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            LottieBuilder.asset("assets/lotties/welcome.json", fit: BoxFit.contain, reverse: true),
          ],
        ),
      ),
    );
  }
}
