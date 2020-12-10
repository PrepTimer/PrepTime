import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:preptime/provider/models/debate_event.dart';
import 'package:preptime/provider/models/event.dart';
import 'package:preptime/provider/models/team.dart';
import 'package:provider/provider.dart';

/// The time label for prep time.
class TimeLabel extends StatelessWidget {
  static const List<FontFeature> _fontFeatures = [FontFeature.tabularFigures()];
  static const Color _primaryColor = Color(0xFFFFFFFF);
  static const Color _secondaryColor = Color(0x44FFFFFF);
  static const FontWeight _fontWeight = FontWeight.w100;
  static const double _fontSize = 100.0;
  static const double _height = 1.3;

  final Team team;
  final bool isDisabled;

  const TimeLabel({Key key, @required this.team, @required this.isDisabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final event = context.watch<Event>() as DebateEvent;
    return StreamBuilder<Duration>(
      initialData: event.initialPrep,
      stream: event.remainingPrep(team),
      builder: (context, timeRemaining) {
        return AutoSizeText(
          _formatDuration(timeRemaining.data),
          maxLines: 1,
          style: TextStyle(
            color: isDisabled ? _secondaryColor : _primaryColor,
            fontFeatures: _fontFeatures,
            fontWeight: _fontWeight,
            fontSize: _fontSize,
            height: _height,
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
