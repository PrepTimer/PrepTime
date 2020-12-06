import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:preptime/provider/prep_timer_provider.dart';
import 'package:preptime/timer.dart';
import 'package:provider/provider.dart';
// import 'package:preptime/home.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  runApp(PrepTime());
}

class PrepTime extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PrepTimeProvider(
      child: MaterialApp(
        theme: ThemeData.dark(),
        home: Timer(),
      ),
    );
  }
}
