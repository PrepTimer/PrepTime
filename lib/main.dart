// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:preptime/models/provider.dart';
import 'package:preptime/theme/style.dart';
import 'package:preptime/screens/timer/timer.dart';
import 'package:preptime/screens/menu/menu.dart';

// TODO: #21 Migrate package to Null Safety (Dart 2.0)
void main() {
  // TODO: #17 Fix status bar color for non-dark themes.
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
