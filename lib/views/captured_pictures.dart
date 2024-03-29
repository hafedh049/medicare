import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:medicare/utils/shared.dart';

class CapturedPictures extends StatefulWidget {
  const CapturedPictures({super.key, required this.capturedPictures});
  final List<String> capturedPictures;
  @override
  State<CapturedPictures> createState() => _CapturedPicturesState();
}

class _CapturedPicturesState extends State<CapturedPictures> {
  late final List<Map<String, dynamic>> _images;
  final GlobalKey<State<StatefulWidget>> _buttonKey = GlobalKey<State<StatefulWidget>>();

  @override
  void initState() {
    _images = <Map<String, dynamic>>[
      for (final String path in widget.capturedPictures)
        <String, dynamic>{
          "path": path,
          "state": false,
          "check": false,
        },
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = (MediaQuery.sizeOf(context).width - 2 * 24 - 20) / 2;
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(FontAwesome.chevron_left_solid, size: 20, color: blueColor),
                ),
                Center(child: Text("Captured Pictures", style: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.w500, color: blueColor)))
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _images.isEmpty
                  ? Center(child: LottieBuilder.asset("assets/lotties/empty.json"))
                  : Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      alignment: WrapAlignment.start,
                      runAlignment: WrapAlignment.start,
                      spacing: 20,
                      runSpacing: 20,
                      children: <Widget>[
                        for (Map<String, dynamic> image in _images)
                          StatefulBuilder(
                            builder: (BuildContext context, void Function(void Function()) _) {
                              return InkWell(
                                splashColor: transparentColor,
                                highlightColor: transparentColor,
                                hoverColor: transparentColor,
                                onLongPress: () => _(() => image["state"] = !image["state"]),
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
                                  width: width,
                                  height: width,
                                  alignment: Alignment.topRight,
                                  padding: const EdgeInsets.all(1),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: blueColor, width: 2),
                                    image: DecorationImage(image: FileImage(File(image["path"])), fit: BoxFit.cover),
                                  ),
                                  child: !image["state"]
                                      ? null
                                      : Row(
                                          children: <Widget>[
                                            const Spacer(),
                                            Checkbox(
                                              fillColor: const MaterialStatePropertyAll(blueColor),
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
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                StatefulBuilder(
                  key: _buttonKey,
                  builder: (BuildContext context, void Function(void Function()) _) {
                    return IgnorePointer(
                      ignoring: _images.where((Map<String, dynamic> element) => element["check"]).isEmpty,
                      child: AnimatedOpacity(
                        duration: 500.ms,
                        opacity: _images.where((Map<String, dynamic> element) => element["check"]).isEmpty ? 0 : 1,
                        child: TextButton(
                          style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(redColor)),
                          onPressed: () {
                            for (final Map<String, dynamic> image in _images.where((Map<String, dynamic> element) => element["check"])) {
                              widget.capturedPictures.remove(image["path"]);
                            }
                            setState(() {});
                          },
                          child: Text("DELETE", style: GoogleFonts.itim(color: whiteColor, fontSize: 16, fontWeight: FontWeight.w500)),
                        ),
                      ),
                    );
                  },
                ),
                const Spacer(),
                TextButton(
                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(greyColor.withOpacity(.8))),
                  onPressed: () => Navigator.pop(context),
                  child: Text("CANCEL", style: GoogleFonts.itim(color: whiteColor, fontSize: 16, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
