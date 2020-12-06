import 'dart:ui';

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
      onTap: () => print('Timer Clicked'),
      child: Container(
        width: _buttonSize.width,
        height: _buttonSize.height,
        child: Column(
          children: [
            Text(
              event.prepName(team).toUpperCase() + ' PREP',
              style: const TextStyle(
                // TODO #9: Fix textScaleFactor bug
                fontSize: 18.0,
                color: Color(0x88FFFFFF),
                fontWeight: FontWeight.w200,
              ),
            ),
            StreamBuilder<Duration>(
              initialData: event.initialPrep,
              stream: event.remainingPrep(team),
              builder: (context, timeRemaining) {
                return Text(
                  _formatDuration(timeRemaining.data),
                  style: const TextStyle(
                    height: 1.3,
                    fontSize: 32.0,
                    fontFeatures: [FontFeature.tabularFigures()],
                    fontWeight: FontWeight.w300,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Takes a duration of the amount of time remaining and returns a formatted
  /// string of the form MM:SS.
  String _formatDuration(Duration time) {
    String minutes = (time.inMinutes % Duration.minutesPerHour).toString();
    String seconds = (time.inSeconds % Duration.secondsPerMinute).toString();
    return '${minutes.padLeft(2, '0')}:${seconds.padLeft(2, '0')}';
  }
}
