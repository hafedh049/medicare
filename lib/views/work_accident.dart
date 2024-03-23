import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
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
    } else {}
  }

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
                Text("Accident de travail", style: GoogleFonts.itim(fontSize: 35, fontWeight: FontWeight.w500, color: blueColor)),
                const SizedBox(height: 20),
                TextField(
                  maxLines: 7,
                  style: GoogleFonts.itim(color: blackColor, fontSize: 16, fontWeight: FontWeight.w500),
                  controller: _typoController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: blueColor, width: 2)),
                    hintText: "Entrez la description d'accident",
                    hintStyle: GoogleFonts.itim(color: blueColor, fontSize: 16, fontWeight: FontWeight.w500),
                    labelText: "Accident",
                    labelStyle: GoogleFonts.itim(color: blueColor),
                  ),
                ),
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
                              final Duration duration = snapshot.hasData ? snapshot.data!.duration : 0.ms;
                              return Text("${_twoDigits(duration.inMinutes.remainder(60))}:${_twoDigits(duration.inSeconds.remainder(60))}", style: GoogleFonts.itim(color: Colors.orange, fontSize: 12));
                            },
                          ),
                          const SizedBox(height: 20),
                          for (final String recordPath in _recordedPaths) ...<Widget>[
                            WaveBubble(path: recordPath),
                            const SizedBox(height: 10),
                          ],
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
