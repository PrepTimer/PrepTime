import 'dart:html';

import 'package:flutter/material.dart';
import 'package:preptime/models/event.dart';
import 'package:preptime/models/event_manager.dart';
// import 'package:preptime/home.dart';
import 'package:preptime/timer.dart';
import 'package:provider/provider.dart';

void main() {
  return runApp(
    ChangeNotifierProvider(
      create: (context) => EventManager(),
      child: PrepTime(),
    ),
  );
}

class PrepTime extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Timer(),
    );
  }
}
