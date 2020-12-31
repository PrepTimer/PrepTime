// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:preptime/models/speech.dart';
import 'package:preptime/models/speech_event.dart';
import 'package:preptime/screens/timer/src/prep_timers/prep_timers.dart';
import 'package:preptime/screens/timer/src/timer_buttons/timer_buttons.dart';
import 'package:preptime/screens/timer/src/timer_ring/timer_ring.dart';
import 'package:preptime/screens/timer/timer.dart';

import '../material_wrapper.dart';

void main() {
  group('Timer', () {
    testWidgets(
      'builds a TimerRing, TimerButtons (and PrepTimers, for debates).',
      (WidgetTester tester) async {
        // TODO: #36 Make timer responsive to different screen sized.
        tester.binding.window.physicalSizeTestValue = Size(390, 844);
        await tester.pumpWidget(TestMaterial.minimalWrapper(Timer()));
        verifyVisibleWidgetOfType(TimerRing);
        verifyVisibleWidgetOfType(TimerButtons);
        verifyVisibleWidgetOfType(PrepTimers);

        await tester.pumpWidget(
          TestMaterial.wrapper(
            Timer(),
            events: [
              SpeechEvent(
                name: 'extemp',
                description: 'NSDA',
                speech: Speech(),
              )
            ],
          ),
        );
        verifyVisibleWidgetOfType(PrepTimers, finds: 0);
      },
      skip: true,
    );

    testWidgets(
      'automatically moves to next page when speech ends',
      (WidgetTester tester) async {
        await tester.pumpWidget(TestMaterial.minimalWrapper(Timer()));
      },
    );
  });
}
