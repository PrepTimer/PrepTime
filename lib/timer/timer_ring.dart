import 'package:flutter/material.dart';
import 'package:preptime/models/event_manager.dart';
import 'package:preptime/speech/ring.dart';
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
              child: Consumer<EventManager>(
                builder: (context, value, child) {
                  return Text(
                    value.getSpeech().getFormattedTime(),
                    style: TextStyle(
                      letterSpacing: -2.0,
                      fontWeight: FontWeight.w200,
                      fontSize: 100.0,
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
