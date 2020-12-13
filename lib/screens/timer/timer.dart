import 'package:flutter/material.dart';
import 'package:preptime/models/event.dart';
import 'package:preptime/screens/timer/src/prep_timers/prep_timers.dart';
import 'package:preptime/screens/timer/src/timer_buttons/timer_buttons.dart';
import 'package:preptime/screens/timer/src/timer_ring/timer_ring.dart';
import 'package:provider/provider.dart';
import 'package:preptime/models/debate_event.dart';

class Timer extends StatelessWidget {
  Timer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
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
