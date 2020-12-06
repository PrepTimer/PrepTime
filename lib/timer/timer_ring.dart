import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:preptime/provider/models/speech.dart';
import 'package:preptime/timer/ring_painter.dart';
import 'package:preptime/timer/speech_indicator.dart';
import 'package:provider/provider.dart';

/// Manages a timer ring including the ring painter, label, title, and dots.
class TimerRing extends StatefulWidget {
  @override
  _TimerRingState createState() => _TimerRingState();
}

class _TimerRingState extends State<TimerRing> with TickerProviderStateMixin {
  @override
  void initState() {
    context.read<Speech>().initController(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.center,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Stack(
          children: <Widget>[
            /// The large, circular ring animation
            Positioned.fill(
              child: RingPainter(),
            ),

            /// The large, white clock text (eg. 00:00.0)
            Align(
              alignment: FractionalOffset.center,
              child: Text(
                context.watch<Speech>().timeRemaining,
                style: const TextStyle(
                  fontFeatures: [FontFeature.tabularFigures()],
                  fontWeight: FontWeight.w200,
                  letterSpacing: -4.0,
                  color: Colors.white,
                  fontSize: 85.0,
                ),
              ),
            ),

            /// The name of the speech being given.
            Align(
              alignment: FractionalOffset(0.5, 0.69),
              child: Text(
                context.watch<Speech>().name.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Color(0x88FFFFFF),
                  fontSize: 18.0,
                ),
              ),
            ),

            /// Optional dots indicating which speech is active.
            Align(
              alignment: FractionalOffset(0.5, 0.8),
              child: SpeechIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
