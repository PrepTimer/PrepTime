import 'package:flutter/material.dart';
import 'package:preptime/models/speech.dart';
import 'package:preptime/timer/timer_button.dart';
import 'package:provider/provider.dart';

class TimerButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Speech speech = context.watch<Speech>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TimerButton(
          primaryText: 'Cancel',
          primaryColor: Color(0xFF999999),
          secondaryColor: Color(0x88999999),
          whenRunning: speech.reset,
        ),
        TimerButton(
          primaryText: 'Start',
          secondaryText: 'Pause',
          primaryColor: Color(0xFF32D74B),
          secondaryColor: Color(0xFFFF9F0A),
          whenPaused: speech.start,
          whenRunning: speech.stop,
        ),
      ],
    );
  }
}
