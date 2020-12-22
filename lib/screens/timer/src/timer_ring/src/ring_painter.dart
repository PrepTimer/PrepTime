import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:preptime/models/debate_event.dart';
import 'package:preptime/models/event.dart';
import 'package:provider/provider.dart';

/// Manages the animation of a circle and arc of the timer ring.
///
/// The timer ring is a custom painter object that paints a round circle
/// with the given background color underneath a colored arc that animates
/// from full to empty.
class RingPainter extends StatelessWidget {
  RingPainter({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Event event = context.watch<Event>();
    bool isPrepRunning = (event is DebateEvent) && event.isAnyRunning;
    return Positioned.fill(
      child: CustomPaint(
        painter: _CustomRingPainter(
          context: context,
          animation: context.watch<Event>().speech.controller,
          isDisabled: isPrepRunning,
        ),
      ),
    );
  }
}

/// Paints the timer and ring from the given speech controller.
class _CustomRingPainter extends CustomPainter {
  static const PaintingStyle _paintStrokeStyle = PaintingStyle.stroke;
  static const StrokeCap _strokeCapStyle = StrokeCap.round;
  static const bool _timerShouldStartEmpty = false;
  static const double _width = 7.0;

  /// The animation object that tracks the path of the object.
  final Animation<double> animation;

  /// Whether the circle ring should be disabled.
  final bool isDisabled;

  /// The context of this painter widget.
  final BuildContext context;

  /// Constructs a new timer ring with the given animation object and colors.
  _CustomRingPainter({
    @required this.context,
    @required this.animation,
    @required this.isDisabled,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = _createPaint();
    _drawBackground(canvas, size, paint);
    if (!isDisabled) _drawForeground(canvas, size, paint);
  }

  @override
  bool shouldRepaint(_CustomRingPainter old) {
    return animation.value != old.animation.value;
  }

  /// Creates a new Paint object.
  Paint _createPaint() {
    return Paint()
      ..color = Theme.of(context).shadowColor
      ..strokeWidth = _width
      ..strokeCap = _strokeCapStyle
      ..style = _paintStrokeStyle;
  }

  /// Draws the background circle to the canvas with the given paint object.
  void _drawBackground(Canvas canvas, Size size, Paint paint) {
    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
  }

  /// Draws the foreground arc to the canvas with the given paint object.
  /// TODO: #32 TimerRing should change color as it spins.
  void _drawForeground(Canvas canvas, Size size, Paint paint) {
    paint.color = Theme.of(context).primaryColor;
    Rect rect = Offset.zero & size;
    double startAngle, sweepAngle;
    if (_timerShouldStartEmpty) {
      startAngle = math.pi * 1.5;
      sweepAngle = (animation.value - 1.0) * 2 * math.pi;
    } else {
      startAngle = math.pi * 1.5 - (1.0 - animation.value) * 2 * math.pi;
      sweepAngle = math.pi * -0.5 - startAngle;
    }
    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }
}
