import 'package:flutter/material.dart';
import 'package:preptime/speech/ring.dart';

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
              child: AnimatedBuilder(
                animation: widget.controller,
                builder: (context, child) {
                  return Text(
                    _getFormattedTime(),
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

  String _getFormattedTime() {
    Duration duration = widget.controller.duration * widget.controller.value;
    String min = duration.inMinutes.toString();
    String sec = (duration.inSeconds % 60).toString().padLeft(2, '0');
    // String ms = (duration.inMilliseconds % 10).toString();
    // print(ms);
    return min + ':' + sec;
  }
}
