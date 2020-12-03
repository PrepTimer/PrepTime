import 'package:flutter/material.dart';
import 'package:preptime/timer/button.dart';

class TimerButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TimerButton(
          buttonText: 'Cancel',
          color: Color(0xFF999999),
          whenRunning: null,
          whenPaused: null,
        ),
        TimerButton(
          buttonText: 'Start',
          color: Color(0xFFFF9F0A), // Green: Color(0xFF32D74B)
          whenRunning: null,
          whenPaused: null,
        ),
      ],
    );
  }
}
