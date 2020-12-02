import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:preptime/models/event_manager.dart';
import 'package:preptime/models/speech.dart';
import 'package:provider/provider.dart';

/// Manages the animation of a circle and arc of the timer ring.
///
/// The timer ring is a custom painter object that paints a round circle
/// with the given background color underneath a colored arc that animates
/// from full to empty.
class Ring extends StatefulWidget {
  @override
  _RingState createState() => _RingState();
}

class _RingState extends State<Ring> with TickerProviderStateMixin {
  Speech speech;

  @override
  void initState() {
    speech = Provider.of<EventManager>(context).event.speech;
    speech.initController(ticker: this, duration: null, onValueChange: null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RingPainter(speech.controller),
    );
  }
}

class _RingPainter extends CustomPainter {
  static const PaintingStyle paintStrokeStyle = PaintingStyle.stroke;
  static const StrokeCap strokeCapStyle = StrokeCap.round;
  static const Color foregroundColor = Color(0xFF32D74B);
  static const Color backgroundColor = Colors.white10;
  static const bool timerShouldStartEmpty = false;
  static const double width = 7.0;

  /// The animation object that tracks the path of the object.
  final Animation<double> animation;

  /// Constructs a new timer ring with the given animation object and colors.
  _RingPainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = _createPaint();
    _drawBackground(canvas, size, paint);
    _drawForeground(canvas, size, paint);
  }

  @override
  bool shouldRepaint(_RingPainter old) {
    return animation.value != old.animation.value;
  }

  /// Creates a new Paint object.
  Paint _createPaint() {
    return Paint()
      ..color = backgroundColor
      ..strokeWidth = width
      ..strokeCap = strokeCapStyle
      ..style = paintStrokeStyle;
  }

  /// Draws the background circle to the canvas with the given paint object.
  void _drawBackground(Canvas canvas, Size size, Paint paint) {
    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
  }

  /// Draws the foreground arc to the canvas with the given paint object.
  void _drawForeground(Canvas canvas, Size size, Paint paint) {
    paint.color = foregroundColor;
    Rect rect = Offset.zero & size;
    double startAngle, sweepAngle;
    if (timerShouldStartEmpty) {
      startAngle = math.pi * 1.5;
      sweepAngle = (animation.value - 1.0) * 2 * math.pi;
    } else {
      startAngle = math.pi * 1.5 - (1.0 - animation.value) * 2 * math.pi;
      sweepAngle = math.pi * -0.5 - startAngle;
    }
    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }
}
