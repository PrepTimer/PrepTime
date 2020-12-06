import 'package:flutter/material.dart';
import 'package:preptime/provider/models/debate_event.dart';
import 'package:preptime/provider/models/event.dart';
import 'package:preptime/provider/models/event_controller.dart';
import 'package:preptime/provider/models/speech.dart';
import 'package:preptime/provider/models/speech_event.dart';
import 'package:provider/provider.dart';

/// Returns a row of page indicators.
class SpeechIndicator extends StatelessWidget {
  static const EdgeInsetsGeometry _gap = EdgeInsets.symmetric(horizontal: 5.0);
  static const MainAxisAlignment _alignCenter = MainAxisAlignment.center;
  static const Duration _fadeDuration = Duration(milliseconds: 500);
  static const Color _inactiveColor = Colors.black12;
  static const Color _activeColor = Colors.black38;
  static const Size _indicatorSize = Size(8.0, 8.0);
  static const double _radiusOfBorder = 5.0;

  @override
  Widget build(BuildContext context) {
    Event event = context.watch<EventController>().event;
    if (event is SpeechEvent) return Container(width: 0.0, height: 0.0);
    List<Speech> speeches = (event as DebateEvent).speeches;
    return Row(
      mainAxisAlignment: _alignCenter,
      children: <Widget>[
        for (int i = 0; i < speeches.length; i++)
          _newIndicator(isActive: speeches[i] == event.speech),
      ],
    );
  }

  /// Returns a new indicator with the associated styling.
  Widget _newIndicator({@required bool isActive}) {
    return AnimatedContainer(
      margin: _gap,
      height: _indicatorSize.height,
      width: _indicatorSize.width,
      duration: _fadeDuration,
      decoration: BoxDecoration(
        color: isActive ? _activeColor : _inactiveColor,
        borderRadius: BorderRadius.circular(_radiusOfBorder),
      ),
    );
  }
}
