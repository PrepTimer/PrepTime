import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:preptime/provider/models/debate_event.dart';
import 'package:preptime/provider/models/event_controller.dart';
import 'package:provider/provider.dart';
import 'package:preptime/provider/models/team.dart';

class PrepTimer extends StatelessWidget {
  static const Size _buttonSize = Size(100, 90);

  /// The team which this prep timer object represents.
  final Team team;

  /// Constructs a new prep timer for the given team.
  PrepTimer({@required this.team});

  @override
  Widget build(BuildContext context) {
    DebateEvent event = (context.watch<EventController>().event as DebateEvent);
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.white10,
      borderRadius: BorderRadius.circular(10),
      onLongPress: () => null,
      onTap: event.isRunning(team)
          ? () => event.stopPrep(team)
          : () => event.startPrep(team),
      child: Container(
        color: event.isRunning(team) ? Colors.blue : Colors.red,
        width: _buttonSize.width,
        height: _buttonSize.height,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            AutoSizeText(
              event.prepName(team).toUpperCase() + ' PREP',
              maxLines: 1,
              style: const TextStyle(
                fontSize: 30,
                color: Color(0x88FFFFFF),
                fontWeight: FontWeight.w200,
              ),
            ),
            StreamBuilder<Duration>(
              initialData: event.initialPrep,
              stream: event.remainingPrep(team),
              builder: (context, timeRemaining) {
                return AutoSizeText(
                  _formatDuration(timeRemaining.data),
                  maxLines: 1,
                  style: const TextStyle(
                    height: 1.3,
                    fontSize: 100.0,
                    fontFeatures: [FontFeature.tabularFigures()],
                    fontWeight: FontWeight.w100,
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  /// Takes a duration of the amount of time remaining and returns a formatted
  /// string of the form MM:SS (if MM >= 10) or M:SS (if M < 10).
  String _formatDuration(Duration time) {
    String seconds = (time.inSeconds % Duration.secondsPerMinute).toString();
    int minutes = (time.inMinutes % Duration.minutesPerHour);
    if (minutes < 10) return '$minutes:${seconds.padLeft(2, '0')}';
    return '${minutes.toString().padLeft(2, '0')}:${seconds.padLeft(2, '0')}';
  }
}
