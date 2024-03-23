import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medicare/utils/callbacks.dart';
import 'package:medicare/views/captured_pictures.dart';

import '../utils/shared.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  final List<String> _capturedPictures = <String>[];

  String _videoPath = "";

  String _twoDigits(n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("Reclamation", style: GoogleFonts.itim(fontSize: 35, fontWeight: FontWeight.w500, color: blueColor)),
                const SizedBox(height: 20),
                InkWell(
                  splashColor: transparentColor,
                  hoverColor: transparentColor,
                  highlightColor: transparentColor,
                  onTap: () {
                    if (_capturedPictures.isEmpty) {
                      showToast(context, "No captured pictures yet");
                    } else {
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => CapturedPictures(capturedPictures: _capturedPictures)));
                    }
                  },
                  child: Container(
                    height: 200,
                    padding: const EdgeInsets.all(16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: blueColor, width: 2),
                    ),
                    child: const Icon(FontAwesome.plus_solid, color: blueColor, size: 35),
                  ),
                ),
                const SizedBox(height: 20),
                StatefulBuilder(
                  builder: (BuildContext context, void Function(void Function()) _) {
                    return InkWell(
                      splashColor: transparentColor,
                      hoverColor: transparentColor,
                      highlightColor: transparentColor,
                      onTap: () async {
                        final XFile? video = await ImagePicker().pickVideo(source: ImageSource.camera, maxDuration: 1.minutes);
                        if (video != null) {
                          _videoPath = video.path;
                          _(() {});
                        }
                      },
                      child: Container(
                        height: 200,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: blueColor, width: 2),
                        ),
                        child: _videoPath.isNotEmpty
                            ? Stack(
                                alignment: Alignment.topRight,
                                children: <Widget>[
                                  IconButton(onPressed: () {}, icon: const Icon(FontAwesome.x_solid, color: redColor, size: 15)),
                                ],
                              )
                            : const Icon(FontAwesome.plus_solid, color: blueColor, size: 35),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
