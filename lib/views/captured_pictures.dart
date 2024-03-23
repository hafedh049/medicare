import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:medicare/utils/shared.dart';

class CapturedPictures extends StatefulWidget {
  const CapturedPictures({super.key, required this.capturedPictures});
  final List<String> capturedPictures;
  @override
  State<CapturedPictures> createState() => _CapturedPicturesState();
}

class _CapturedPicturesState extends State<CapturedPictures> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(FontAwesome.chevron_left_solid, size: 25, color: blueColor),
                  ),
                ),
                Center(child: Text("Captured Pictures", style: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.w500, color: blueColor)))
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.start,
              spacing: 20,
              runSpacing: 20,
              children: <Widget>[
                for (final String picturePath in widget.capturedPictures)
                  InkWell(
                    splashColor: transparentColor,
                    highlightColor: transparentColor,
                    hoverColor: transparentColor,
                    onTap: () => showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        content: SizedBox(
                          width: MediaQuery.sizeOf(context).width * .9,
                          height: MediaQuery.sizeOf(context).height * .9,
                          child: Stack(
                            alignment: Alignment.topLeft,
                            children: <Widget>[
                              Image.file(File(picturePath), fit: BoxFit.cover),
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(FontAwesome.chevron_left_solid, size: 25, color: blueColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: blueColor, width: 2),
                        image: DecorationImage(image: FileImage(File(picturePath)), fit: BoxFit.cover),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
