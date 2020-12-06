import 'package:flutter/material.dart';
import 'package:preptime/timer/timer_buttons.dart';
import 'package:preptime/timer_ring/timer_ring.dart';

class Timer extends StatelessWidget {
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
              TimerButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
