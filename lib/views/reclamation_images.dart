import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../utils/shared.dart';

class ReclamationImages extends StatefulWidget {
  const ReclamationImages({super.key, required this.images, required this.callback});
  final List<String> images;
  final void Function() callback;

  @override
  State<ReclamationImages> createState() => _ReclamationImagesState();
}

class _ReclamationImagesState extends State<ReclamationImages> {
  final GlobalKey<State<StatefulWidget>> _buttonKey = GlobalKey<State<StatefulWidget>>();

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> images = widget.images.map((String e) => <String, dynamic>{"path": e, "check": false}).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: images.isEmpty
              ? Center(child: LottieBuilder.asset("assets/lotties/empty.json"))
              : SingleChildScrollView(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    spacing: 20,
                    runSpacing: 20,
                    children: <Widget>[
                      for (Map<String, dynamic> image in images)
                        StatefulBuilder(
                          builder: (BuildContext context, void Function(void Function()) _) {
                            return InkWell(
                              splashColor: transparentColor,
                              highlightColor: transparentColor,
                              hoverColor: transparentColor,
                              onTap: () => showModalBottomSheet(
                                backgroundColor: scaffoldColor,
                                context: context,
                                builder: (BuildContext context) => Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    image: DecorationImage(image: FileImage(File(image["path"])), fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                              child: Container(
                                width: 90,
                                height: 90,
                                alignment: Alignment.topRight,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: blueColor, width: 2),
                                  image: DecorationImage(image: FileImage(File(image["path"])), fit: BoxFit.cover),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    const Spacer(),
                                    Checkbox(
                                      fillColor: MaterialStatePropertyAll(blueColor.withOpacity(.3)),
                                      checkColor: whiteColor,
                                      value: image["check"],
                                      onChanged: (bool? value) {
                                        _(() => image["check"] = value!);
                                        _buttonKey.currentState!.setState(() {});
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
        ),
        StatefulBuilder(
          key: _buttonKey,
          builder: (BuildContext context, void Function(void Function()) _) {
            return IgnorePointer(
              ignoring: images.where((Map<String, dynamic> element) => element["check"]).isEmpty,
              child: AnimatedOpacity(
                duration: 500.ms,
                opacity: images.where((Map<String, dynamic> element) => element["check"]).isEmpty ? 0 : 1,
                child: TextButton(
                  style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(redColor)),
                  onPressed: () {
                    for (final Map<String, dynamic> image in List<Map<String, dynamic>>.from(images.where((Map<String, dynamic> element) => element["check"]))) {
                      widget.images.remove(image["path"]);
                      images.removeWhere((Map<String, dynamic> element) => element["path"] == image["path"]);
                    }
                    setState(() {});
                    widget.callback();
                  },
                  child: Text("DELETE", style: GoogleFonts.itim(color: whiteColor, fontSize: 16, fontWeight: FontWeight.w500)),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
