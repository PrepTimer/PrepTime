import 'package:flutter/material.dart';
// import 'package:preptime/home.dart';
import 'package:preptime/timer.dart';
import '';

void main() => runApp(MultiProvider(providers: [
  ChangeNotifierProvider
], child: PrepTime()));

class PrepTime extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Timer(),
    );
  }
}
