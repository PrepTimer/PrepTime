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
          textColor: Color(0xFF999999),
          onPressed: () {},
        ),
        TimerButton(
          buttonText: 'Start',
          textColor: Color(0xFFFF9F0A), // Color(0xFF32D74B)
          onPressed: () {},
        ),
      ],
    );
  }
}
