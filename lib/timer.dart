import 'package:flutter/material.dart';
import 'package:preptime/prep_timers/prep_timers.dart';
import 'package:preptime/provider/models/event.dart';
import 'package:provider/provider.dart';
import 'package:preptime/provider/models/debate_event.dart';
import 'package:preptime/timer_buttons/timer_buttons.dart';
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
              if (context.watch<Event>() is DebateEvent) ...[
                SizedBox(height: 20),
                PrepTimers(),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
