import 'package:flutter/material.dart';
import 'package:preptime/speech/button.dart';
import 'package:preptime/speech/timer_ring.dart';

class Timer extends StatelessWidget {
//   @override
//   _TimerState createState() => _TimerState();
// }

// class _TimerState extends State<Timer> with TickerProviderStateMixin {
  // static const int timerDuration = 5;

  // AnimationController controller;

  // @override
  // void initState() {
  //   super.initState();
  //   controller = AnimationController(
  //     vsync: this,
  //     value: 1.0,
  //     duration: Duration(seconds: timerDuration),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TimerRing(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TimerButton(
                    buttonText: 'Cancel',
                    textColor: Color(0xFF999999),
                    onPressed: () {},
                  ),
                  TimerButton(
                    buttonText: 'Start',
                    textColor: Color(0xFFFF9F0A), // Color(0xFF32D74B)
                    onPressed: () {},
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
