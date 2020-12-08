import 'package:flutter/material.dart';
import 'package:preptime/provider/models/speech.dart';
import 'package:preptime/provider/models/speech_status.dart';
import 'package:preptime/timer_buttons/src/timer_button.dart';
import 'package:preptime/utilities/utilities.dart';
import 'package:provider/provider.dart';

class TimerButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Speech speech = context.watch<Speech>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // TODO: #7 Clean up timer buttons.
        TimerButton(
          callback: {
            SpeechStatus.stoppedAtBeginning: null,
            SpeechStatus.runningForward: () => _resetTimer(context, speech),
            SpeechStatus.pausedInMiddle: () => _resetTimer(context, speech),
            SpeechStatus.completed: null,
          },
          color: {
            SpeechStatus.stoppedAtBeginning: Color(0xFF8E8E93),
            SpeechStatus.runningForward: Color(0xFF8E8E93),
            SpeechStatus.pausedInMiddle: Color(0xFF8E8E93),
            SpeechStatus.completed: Color(0xFF8E8E93),
          },
          text: {
            SpeechStatus.stoppedAtBeginning: 'Cancel',
            SpeechStatus.runningForward: 'Cancel',
            SpeechStatus.pausedInMiddle: 'Cancel',
            SpeechStatus.completed: 'Cancel',
          },
        ),
        TimerButton(
          callback: {
            SpeechStatus.stoppedAtBeginning: speech.start,
            SpeechStatus.runningForward: speech.stop,
            SpeechStatus.pausedInMiddle: speech.resume,
            SpeechStatus.completed: speech.start,
          },
          color: {
            SpeechStatus.stoppedAtBeginning: Color(0xFF32D74B),
            SpeechStatus.runningForward: Color(0xFFFF9F0A),
            SpeechStatus.pausedInMiddle: Color(0xFF32D74B),
            SpeechStatus.completed: Color(0xFF32D74B),
          },
          text: {
            SpeechStatus.stoppedAtBeginning: 'Start',
            SpeechStatus.runningForward: 'Pause',
            SpeechStatus.pausedInMiddle: 'Resume',
            SpeechStatus.completed: 'Restart',
          },
        ),
      ],
    );
  }

  void _resetTimer(BuildContext context, Speech speech) {
    ClearTimer.showDialog(
      context,
      title: 'Clear Timer',
      content: 'Are you sure you want to reset the timer?',
      destructiveActionLabel: 'Clear',
      cancelActionLabel: 'Cancel',
      destructiveAction: speech.reset,
      cancelAction: () {}, // TODO: dismiss dialog!
    );
  }
}
