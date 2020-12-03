import 'package:flutter/material.dart';
import 'package:preptime/models/speech.dart';
import 'package:preptime/timer/ring.dart';
import 'package:provider/provider.dart';

/// Manages a timer ring including the ring painter, label, title, and dots.
class TimerRing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.center,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Ring(),
            ),
            Align(
              alignment: FractionalOffset.center,
              child: Consumer<Speech>(
                builder: (context, speech, child) {
                  print('updating');
                  return Text(
                    speech.timeRemaining,
                    style: const TextStyle(
                      letterSpacing: -2.0,
                      fontWeight: FontWeight.w200,
                      fontSize: 85.0,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
