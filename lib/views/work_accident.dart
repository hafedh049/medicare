import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:medicare/utils/callbacks.dart';
import 'package:medicare/views/bubble.dart';
import 'package:medicare/views/captured_pictures.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/shared.dart';

class WorkAccident extends StatefulWidget {
  const WorkAccident({super.key});

  @override
  State<WorkAccident> createState() => _WorkAccidentState();
}

class _WorkAccidentState extends State<WorkAccident> {
  final TextEditingController _typoController = TextEditingController();

  final GlobalKey<State<StatefulWidget>> _micKey = GlobalKey<State<StatefulWidget>>();
  final GlobalKey<State<StatefulWidget>> _voicesKey = GlobalKey<State<StatefulWidget>>();
  final GlobalKey<State<StatefulWidget>> _picturesKey = GlobalKey<State<StatefulWidget>>();

  @override
  void dispose() {
    _typoController.dispose();
    _recorder.closeRecorder();
    super.dispose();
  }

  final List<String> _capturedPictures = <String>[];
  final List<String> _recordedPaths = <String>[];

  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();

  bool _recorderIsReady = false;

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    final PermissionStatus status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      // ignore: use_build_context_synchronously
      showToast(context, "Permission denied", color: redColor);
      return;
    }
    await _recorder.openRecorder();
    await _recorder.setSubscriptionDuration(500.ms);
    _recorderIsReady = true;
  }

  Future<void> _startRecording() async {
    if (!_recorderIsReady) return;
    await _recorder.startRecorder(toFile: "audio");
  }

  Future<void> _stopRecording() async {
    if (!_recorderIsReady) return;
    final String? path = await _recorder.stopRecorder();
    if (path != null) {
      _recordedPaths.insert(0, path);
      _micKey.currentState!.setState(() {});
    }
  }

  String _twoDigits(n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: scaffoldColor,
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(FontAwesome.circle_chevron_left_solid, color: blueColor, size: 20)),
                  const SizedBox(width: 10),
                  Expanded(child: Text("Accident de travail", style: GoogleFonts.itim(fontSize: 35, fontWeight: FontWeight.w500, color: blueColor))),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: TextField(
                  style: GoogleFonts.itim(color: whiteColor, fontSize: 16, fontWeight: FontWeight.w500),
                  controller: _typoController,
                  expands: true,
                  minLines: null,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: blueColor, width: 2)),
                    hintText: "Entrer la description d'accident",
                    hintStyle: GoogleFonts.itim(color: whiteColor, fontSize: 16, fontWeight: FontWeight.w500),
                    labelText: "Accident",
                    labelStyle: GoogleFonts.itim(color: whiteColor),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                splashColor: transparentColor,
                hoverColor: transparentColor,
                highlightColor: transparentColor,
                onLongPress: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => CapturedPictures(
                      capturedPictures: _capturedPictures,
                      callback: () => _picturesKey.currentState!.setState(() {}),
                    ),
                  ),
                ),
                onTap: () async {
                  final List<XFile> images = await ImagePicker().pickMultiImage();
                  if (images.isNotEmpty) {
                    for (final XFile image in images) {
                      final File? croppedImage = await ImageCropper().cropImage(sourcePath: image.path);
                      if (croppedImage != null) {
                        _capturedPictures.add(croppedImage.path);
                      }
                    }
                  }
                  _picturesKey.currentState!.setState(() {});
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
              Center(
                child: StatefulBuilder(
                  key: _micKey,
                  builder: (BuildContext context, void Function(void Function()) _) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        InkWell(
                          hoverColor: transparentColor,
                          splashColor: transparentColor,
                          highlightColor: transparentColor,
                          onTap: () async {
                            if (_recorder.isRecording) {
                              await _stopRecording();
                              // ignore: use_build_context_synchronously
                              showToast(context, "Voice has been recorded");
                            } else {
                              await _startRecording();
                            }
                            _(() {});
                          },
                          child: LottieBuilder.asset("assets/lotties/record.json", animate: _recorder.isRecording, reverse: true),
                        ),
                        StreamBuilder<RecordingDisposition>(
                          stream: _recorder.onProgress,
                          builder: (BuildContext context, AsyncSnapshot<RecordingDisposition> snapshot) {
                            final Duration duration = _recorder.isStopped
                                ? 0.ms
                                : snapshot.hasData
                                    ? snapshot.data!.duration
                                    : 0.ms;
                            return InkWell(
                              highlightColor: transparentColor,
                              hoverColor: transparentColor,
                              splashColor: transparentColor,
                              onTap: () {
                                showModalBottomSheet(
                                  backgroundColor: scaffoldColor,
                                  context: context,
                                  builder: (BuildContext contextt) => Container(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text("Voices", style: GoogleFonts.itim(color: blueColor, fontSize: 16, fontWeight: FontWeight.w500)),
                                        const SizedBox(height: 20),
                                        Expanded(
                                          child: StatefulBuilder(
                                            key: _voicesKey,
                                            builder: (BuildContext context, void Function(void Function()) _) {
                                              return _recordedPaths.isEmpty
                                                  ? Center(child: LottieBuilder.asset("assets/lotties/empty.json"))
                                                  : ListView.separated(
                                                      itemBuilder: (BuildContext context, int index) => GestureDetector(
                                                        onLongPress: () {
                                                          showModalBottomSheet(
                                                            context: context,
                                                            builder: (BuildContext context) => Container(
                                                              padding: const EdgeInsets.all(16),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: <Widget>[
                                                                  Text("Do you want to delete this voice record ?", style: GoogleFonts.itim(color: whiteColor, fontSize: 16, fontWeight: FontWeight.w500)),
                                                                  const SizedBox(height: 20),
                                                                  Row(
                                                                    children: <Widget>[
                                                                      TextButton(
                                                                        style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(redColor)),
                                                                        onPressed: () {
                                                                          _voicesKey.currentState!.setState(() => _recordedPaths.clear());
                                                                        },
                                                                        child: Text("CONFIRM", style: GoogleFonts.itim(color: whiteColor, fontSize: 16, fontWeight: FontWeight.w500)),
                                                                      ),
                                                                      const Spacer(),
                                                                      TextButton(
                                                                        style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(greyColor.withOpacity(.8))),
                                                                        onPressed: () => Navigator.pop(contextt),
                                                                        child: Text("CANCEL", style: GoogleFonts.itim(color: whiteColor, fontSize: 16, fontWeight: FontWeight.w500)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: WaveBubble(path: _recordedPaths[index]),
                                                      ),
                                                      separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10),
                                                      itemCount: _recordedPaths.length,
                                                      padding: EdgeInsets.zero,
                                                      physics: const BouncingScrollPhysics(),
                                                    );
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          children: <Widget>[
                                            TextButton(
                                              style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(redColor)),
                                              onPressed: () {
                                                _voicesKey.currentState!.setState(() => _recordedPaths.clear());
                                              },
                                              child: Text("DELETE ALL", style: GoogleFonts.itim(color: whiteColor, fontSize: 16, fontWeight: FontWeight.w500)),
                                            ),
                                            const Spacer(),
                                            TextButton(
                                              style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(greyColor.withOpacity(.8))),
                                              onPressed: () => Navigator.pop(contextt),
                                              child: Text("CANCEL", style: GoogleFonts.itim(color: whiteColor, fontSize: 16, fontWeight: FontWeight.w500)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.orange.withOpacity(.2)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      "${_twoDigits(duration.inMinutes.remainder(60))}:${_twoDigits(duration.inSeconds.remainder(60))}",
                                      style: GoogleFonts.itim(color: Colors.orange, fontSize: 12),
                                    ),
                                    _recordedPaths.isEmpty
                                        ? const SizedBox()
                                        : Container(
                                            margin: const EdgeInsets.only(left: 10),
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 2, color: Colors.orange)),
                                            child: Text(_recordedPaths.length.toString(), style: GoogleFonts.itim(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.orange)),
                                          ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                splashColor: transparentColor,
                hoverColor: transparentColor,
                highlightColor: transparentColor,
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: whiteColor, width: 2)),
                  child: Text("Confirm", style: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.w500, color: whiteColor)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
