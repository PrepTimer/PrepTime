import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:preptime/provider/models/debate_event.dart';
import 'package:preptime/provider/models/event_controller.dart';
import 'package:preptime/provider/models/team.dart';
import 'package:provider/provider.dart';

/// The time label for prep time.
class TimeLabel extends StatelessWidget {
  static const Color primaryColor = Color(0xFFFFFFFF);
  static const Color secondaryColor = Color(0x88FFFFFF);

  final Team team;

  /// TODO: #12 Add keys to all widget constructors.
  const TimeLabel({@required this.team});

  @override
  Widget build(BuildContext context) {
    DebateEvent event = (context.watch<EventController>().event as DebateEvent);
    return StreamBuilder<Duration>(
      initialData: event.initialPrep,
      stream: event.remainingPrep(team),
      builder: (context, timeRemaining) {
        return AutoSizeText(
          _formatDuration(timeRemaining.data),
          maxLines: 1,
          style: TextStyle(
            color: event.isOtherRunning(team) ? secondaryColor : primaryColor,
            fontFeatures: [FontFeature.tabularFigures()],
            fontWeight: FontWeight.w100,
            fontSize: 100.0,
            height: 1.3,
          ),
        );
      },
    );
  }

  /// Formats a duration as a string.
  ///
  /// Takes a duration of the amount of time remaining and returns a formatted
  /// string of the form MM:SS (if MM >= 10) or M:SS (if M < 10).
  String _formatDuration(Duration time) {
    String seconds = (time.inSeconds % Duration.secondsPerMinute).toString();
    int minutes = (time.inMinutes % Duration.minutesPerHour);
    if (minutes < 10) return '$minutes:${seconds.padLeft(2, '0')}';
    return '${minutes.toString().padLeft(2, '0')}:${seconds.padLeft(2, '0')}';
  }
}
