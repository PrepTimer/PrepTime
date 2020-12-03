import 'package:flutter/material.dart';
import 'package:preptime/models/event_manager.dart';
import 'package:preptime/models/speech.dart';
import 'package:preptime/timer/button.dart';
import 'package:provider/provider.dart';

class TimerButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Speech s = Provider.of<EventManager>(context, listen: false).event.speech;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TimerButton(
          buttonText: 'Cancel',
          color: Color(0xFF999999),
          altColor: Color(0x88999999),
          whenRunning: null,
          whenPaused: s.reset,
        ),
        TimerButton(
          buttonText: 'Start',
          color: Color(0xFF32D74B),
          altColor: Color(0xFFFF9F0A),
          whenRunning: s.stop,
          whenPaused: s.start,
        ),
      ],
    );
  }
}
