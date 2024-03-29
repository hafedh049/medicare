import 'package:animated_loading_border/animated_loading_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medicare/utils/shared.dart';
import 'package:medicare/views/report.dart';
import 'package:medicare/views/work_accident.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Map<String, dynamic>> _buttons = <Map<String, dynamic>>[
    <String, dynamic>{
      "title": "Accident de travail",
      "widget": const WorkAccident(),
    },
    <String, dynamic>{
      "title": "Réclamation",
      "widget": const Report(),
    },
    <String, dynamic>{
      "title": "Prise du Rendez-Vous",
      "widget": Container(),
    },
    <String, dynamic>{
      "title": "AES",
      "widget": Container(),
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (final Map<String, dynamic> item in _buttons) ...<Widget>[
                InkWell(
                  splashColor: transparentColor,
                  highlightColor: transparentColor,
                  hoverColor: transparentColor,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => item["widget"])),
                  child: AnimatedLoadingBorder(
                    borderColor: blueColor,
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: darkColor),
                      padding: const EdgeInsets.all(8),
                      child: Text(item["title"], style: GoogleFonts.itim(fontSize: 35, fontWeight: FontWeight.w500, color: blueColor)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
