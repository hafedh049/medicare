import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:medicare/utils/shared.dart';
import 'package:voice_message_package/voice_message_package.dart';

class WaveBubble extends StatefulWidget {
  final String path;

  const WaveBubble({super.key, required this.path});

  @override
  State<WaveBubble> createState() => _WaveBubbleState();
}

class _WaveBubbleState extends State<WaveBubble> {
  late final VoiceController _voiceController;

  @override
  void initState() {
    _voiceController = VoiceController(
      audioSrc: widget.path,
      maxDuration: 1.seconds,
      isFile: false,
      onComplete: () {},
      onPause: () {},
      onPlaying: () {},
    );
    super.initState();
  }

  @override
  void dispose() {
    _voiceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: blueColor, width: 2)),
      child: VoiceMessageView(
        backgroundColor: transparentColor,
        activeSliderColor: blueColor,
        circlesColor: blueColor,
        notActiveSliderColor: transparentColor,
        controller: _voiceController,
        innerPadding: 4,
      ),
    );
  }
}
