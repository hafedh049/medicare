import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:medicare/utils/shared.dart';
import 'package:path_provider/path_provider.dart';

class WaveBubble extends StatefulWidget {
  final String path;

  const WaveBubble({super.key, required this.path});

  @override
  State<WaveBubble> createState() => _WaveBubbleState();
}

class _WaveBubbleState extends State<WaveBubble> {
  late File file;

  late PlayerController controller;
  late StreamSubscription<PlayerState> playerStateSubscription;

  final playerWaveStyle = const PlayerWaveStyle(fixedWaveColor: Colors.white54, liveWaveColor: Colors.white, spacing: 6);

  @override
  void initState() {
    controller = PlayerController();
    _preparePlayer();
    playerStateSubscription = controller.onPlayerStateChanged.listen((PlayerState _) => setState(() {}));
    super.initState();
  }

  void _preparePlayer() async {
    // Opening file from assets folder

    file = File('${(await getApplicationDocumentsDirectory()).path}/audio/${(await getApplicationDocumentsDirectory()).path}/${formatDate(DateTime.now(), const <String>[dd, "/", mm, "/", yyyy, " ", HH, ":", nn, ":", ss, " ", am])}.mp3');

    // Prepare player with extracting waveform if index is even.
    controller.preparePlayer(path: file.path, shouldExtractWaveform: true);
    // Extracting waveform separately if index is odd.
    controller.extractWaveformData(path: file.path, noOfSamples: playerWaveStyle.getSamplesForWidth(200)).then((List<double> waveformData) => debugPrint(waveformData.toString()));
  }

  @override
  void dispose() {
    playerStateSubscription.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (!controller.playerState.isStopped)
            IconButton(
              onPressed: () async => controller.playerState.isPlaying ? await controller.pausePlayer() : await controller.startPlayer(finishMode: FinishMode.loop),
              icon: Icon(controller.playerState.isPlaying ? Icons.stop : Icons.play_arrow, color: blueColor, size: 25),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
          Expanded(
            child: AudioFileWaveforms(
              backgroundColor: blueColor,
              // waveformData: [],
              size: Size(MediaQuery.of(context).size.width, 40),
              playerController: controller,
              waveformType: WaveformType.fitWidth,
              continuousWaveform: true,
              playerWaveStyle: playerWaveStyle,
            ),
          ),
        ],
      ),
    );
  }
}
