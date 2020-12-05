import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:preptime/models/speech.dart';
import 'package:preptime/timer/ring_painter.dart';
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
            Positioned.fill(
              child: RingPainter(),
            ),
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
          ],
        ),
      ),
    );
  }
}
