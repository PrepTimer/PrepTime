import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:preptime/provider/prep_timer_provider.dart';
import 'package:preptime/style.dart';
import 'package:preptime/timer.dart';
import 'package:provider/provider.dart';
import 'package:preptime/menu.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  runApp(PrepTime());
}

class PrepTime extends StatelessWidget {
  PrepTime({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PrepTimeProvider(
      child: MaterialApp(
        theme: PrepTimeThemeData.darkTheme,
        title: 'Prep Time',
        initialRoute: '/',
        routes: {
          '/': (context) => Timer(),
          '/menu': (context) => Menu(),
        },
      ),
    );
  }
}
