import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medicare/views/reclamation_images.dart';
import 'package:video_player/video_player.dart';

import '../utils/shared.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  final List<String> _capturedPictures = <String>[];

  String _videoPath = "";

  late VideoPlayerController _controller;

  final GlobalKey<State<StatefulWidget>> _picturesKey = GlobalKey<State<StatefulWidget>>();
  final GlobalKey<State<StatefulWidget>> _displayImages = GlobalKey<State<StatefulWidget>>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: scaffoldColor,
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Reclamation", style: GoogleFonts.itim(fontSize: 35, fontWeight: FontWeight.w500, color: blueColor)),
              const SizedBox(height: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    InkWell(
                      splashColor: transparentColor,
                      hoverColor: transparentColor,
                      highlightColor: transparentColor,
                      onTap: () async {
                        final List<XFile> images = await ImagePicker().pickMultiImage();
                        if (images.isNotEmpty) {
                          for (final XFile image in images) {
                            final File? croppedImage = await ImageCropper().cropImage(sourcePath: image.path);
                            if (croppedImage != null) {
                              _capturedPictures.add(croppedImage.path);
                              _picturesKey.currentState!.setState(() {});
                              _displayImages.currentState!.setState(() {});
                            }
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: blueColor, width: 2)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text("Select images", style: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.w500, color: blueColor)),
                            const SizedBox(width: 10),
                            StatefulBuilder(
                              key: _picturesKey,
                              builder: (BuildContext context, void Function(void Function()) _) {
                                return _capturedPictures.isEmpty
                                    ? const SizedBox()
                                    : Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 2, color: blueColor)),
                                        child: Text(_capturedPictures.length.toString(), style: GoogleFonts.itim(fontSize: 12, fontWeight: FontWeight.w500, color: blueColor)),
                                      );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: StatefulBuilder(
                        key: _displayImages,
                        builder: (BuildContext context, void Function(void Function()) _) {
                          return ReclamationImages(images: _capturedPictures, callback: () => _picturesKey.currentState!.setState(() {}));
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: StatefulBuilder(
                  builder: (BuildContext context, void Function(void Function()) _) {
                    return InkWell(
                      splashColor: transparentColor,
                      hoverColor: transparentColor,
                      highlightColor: transparentColor,
                      onTap: () async {
                        final XFile? video = await ImagePicker().pickVideo(source: ImageSource.camera, maxDuration: 1.minutes);
                        if (video != null) {
                          _videoPath = video.path;
                          _controller = VideoPlayerController.file(File(_videoPath));
                          await _controller.initialize();
                          _(() {});
                        }
                      },
                      child: Container(
                        height: 200,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: blueColor, width: 2)),
                        child: _videoPath.isNotEmpty
                            ? Stack(
                                alignment: Alignment.topRight,
                                children: <Widget>[
                                  VideoPlayer(_controller),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      IconButton(onPressed: () {}, icon: const Icon(FontAwesome.x_solid, color: redColor, size: 15)),
                                      const Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Row(
                                          children: <Widget>[
                                            IconButton(onPressed: () async => await _controller.play(), icon: const Icon(FontAwesome.play_solid, color: whiteColor, size: 15)),
                                            const Spacer(),
                                            IconButton(onPressed: () async => await _controller.pause(), icon: const Icon(FontAwesome.pause_solid, color: blueColor, size: 15)),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Select Video", style: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.w500, color: blueColor)),
                                  const SizedBox(height: 20),
                                  const Icon(FontAwesome.plus_solid, color: blueColor, size: 35),
                                ],
                              ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
