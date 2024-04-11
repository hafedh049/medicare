import 'dart:math';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surveillant/models/user_model.dart';
import 'package:uuid/uuid.dart';

import '../utils/shared.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<RdvModel> _rdvs = List<RdvModel>.generate(
    1000,
    (int index) => RdvModel(
      phone: "(+216) ${Random().nextInt(90) + 10} ${Random().nextInt(900) + 100} ${Random().nextInt(900) + 100}",
      username: "Username ${(index + 1) * Random().nextInt(4000)}",
      uid: const Uuid().v8g(),
      rdvID: const Uuid().v8g(),
      timestamp: DateTime.now(),
      description: "Description ${(index + 1) * Random().nextInt(4000)}",
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Les rendez-vous actuelles", style: GoogleFonts.abel(fontSize: 35, color: blueColor, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemBuilder: (BuildContext context, int index) => ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      decoration: const BoxDecoration(color: darkColor),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: blueColor,
                                  boxShadow: <BoxShadow>[BoxShadow(color: whiteColor.withOpacity(.2), blurStyle: BlurStyle.outer, offset: const Offset(3, 3))],
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Text("NAME", style: GoogleFonts.abel(fontSize: 16, color: whiteColor, fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(width: 20),
                              Text(_rdvs[index].username.toUpperCase(), style: GoogleFonts.abel(fontSize: 16, color: whiteColor, fontWeight: FontWeight.w500)),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: blueColor,
                                  boxShadow: <BoxShadow>[BoxShadow(color: whiteColor.withOpacity(.2), blurStyle: BlurStyle.outer, offset: const Offset(3, 3))],
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Text("PHONE", style: GoogleFonts.abel(fontSize: 16, color: whiteColor, fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(width: 20),
                              Text(_rdvs[index].phone, style: GoogleFonts.abel(fontSize: 16, color: whiteColor, fontWeight: FontWeight.w500)),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: blueColor,
                                  boxShadow: <BoxShadow>[BoxShadow(color: whiteColor.withOpacity(.2), blurStyle: BlurStyle.outer, offset: const Offset(3, 3))],
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Text("DATE", style: GoogleFonts.abel(fontSize: 16, color: whiteColor, fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(width: 20),
                              Text(formatDate(_rdvs[index].timestamp, const <String>[dd, "/", mm, "/", yyyy]), style: GoogleFonts.abel(fontSize: 16, color: whiteColor, fontWeight: FontWeight.w500)),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: blueColor,
                                  boxShadow: <BoxShadow>[BoxShadow(color: whiteColor.withOpacity(.2), blurStyle: BlurStyle.outer, offset: const Offset(3, 3))],
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Text("DESCRIPTION", style: GoogleFonts.abel(fontSize: 16, color: whiteColor, fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(width: 20),
                              Flexible(child: Text(_rdvs[index].description, style: GoogleFonts.abel(fontSize: 16, color: whiteColor, fontWeight: FontWeight.w500))),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: <Widget>[
                              InkWell(
                                highlightColor: transparentColor,
                                splashColor: transparentColor,
                                hoverColor: transparentColor,
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) => Padding(
                                      padding: const EdgeInsets.all(24),
                                      child: DatePickerDialog(
                                        firstDate: DateTime(1960),
                                        lastDate: DateTime(2080),
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: redColor,
                                    boxShadow: <BoxShadow>[BoxShadow(color: whiteColor.withOpacity(.2), blurStyle: BlurStyle.outer, offset: const Offset(3, 3))],
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: Text("CHOISIR UNE AUTRE DATE", style: GoogleFonts.abel(fontSize: 16, color: whiteColor, fontWeight: FontWeight.bold)),
                                ),
                              ),
                              const SizedBox(width: 20),
                              InkWell(
                                highlightColor: transparentColor,
                                splashColor: transparentColor,
                                hoverColor: transparentColor,
                                onTap: () {},
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: greenColor,
                                    boxShadow: <BoxShadow>[BoxShadow(color: whiteColor.withOpacity(.2), blurStyle: BlurStyle.outer, offset: const Offset(3, 3))],
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: Text("CONFIRMER", style: GoogleFonts.abel(fontSize: 16, color: whiteColor, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20),
                  itemCount: _rdvs.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
