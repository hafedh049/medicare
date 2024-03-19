import 'package:animated_loading_border/animated_loading_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medicare/utils/shared.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InkWell(
                splashColor: transparentColor,
                highlightColor: transparentColor,
                hoverColor: transparentColor,
                onTap: () {},
                child: AnimatedLoadingBorder(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "AES",
                      style: GoogleFonts.itim(fontSize: 35, fontWeight: FontWeight.w500, color: blueColor),
                    ),
                  ),
                ),
              ),
              InkWell(
                splashColor: transparentColor,
                highlightColor: transparentColor,
                hoverColor: transparentColor,
                onTap: () {},
                child: AnimatedLoadingBorder(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "OTHERS",
                      style: GoogleFonts.itim(fontSize: 35, fontWeight: FontWeight.w500, color: blueColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
