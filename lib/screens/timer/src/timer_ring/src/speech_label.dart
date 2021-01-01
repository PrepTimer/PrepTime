// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

import 'package:flutter/material.dart';
import 'package:preptime/models/debate_event.dart';
import 'package:preptime/models/event.dart';
import 'package:provider/provider.dart';

/// The name of the speech currently being given.
class SpeechLabel extends StatelessWidget {
  SpeechLabel({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Event event = context.watch<Event>();
    bool isDisabled = (event is DebateEvent) && event.isAnyPrepRunning;
    return Text(
      event.speech.name.toUpperCase(),
      style: isDisabled
          ? Theme.of(context).textTheme.subtitle2
          : Theme.of(context).textTheme.subtitle1,
    );
  }
}
