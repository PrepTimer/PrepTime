// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

import 'package:flutter/material.dart';
import 'package:preptime/models/debate_event.dart';
import 'package:preptime/models/event.dart';
import 'package:preptime/screens/timer/src/timer_ring/src/clock_label.dart';
import 'package:provider/provider.dart';

/// A horizontal scroller of clock labels.
///
/// This widget must only be built in a DebateEvent context.
class ClockCarousel extends StatelessWidget {
  ClockCarousel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DebateEvent event = context.watch<Event>() as DebateEvent;
    return PageView.builder(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      controller: event.pageController,
      onPageChanged: (index) => _updateNextOrPrevSpeech(index, context),
      itemCount: event.numSpeeches,
      itemBuilder: (_, index) => ClockLabel.fromIndex(index),
    );
  }

  void _updateNextOrPrevSpeech(int newPageIndex, BuildContext context) {
    DebateEvent event = Provider.of<Event>(context, listen: false);
    if (newPageIndex > event.currentSpeechIndex) {
      event.nextSpeech();
    } else if (newPageIndex < event.currentSpeechIndex) {
      event.prevSpeech();
      event.reset();
    }
  }
}
