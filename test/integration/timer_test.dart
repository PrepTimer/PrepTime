// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

import 'dart:ui';

import 'package:fake_async/fake_async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:preptime/models/platform_info.dart';
import 'package:preptime/models/speech.dart';
import 'package:preptime/models/speech_event.dart';
import 'package:preptime/screens/timer/src/prep_timers/prep_timers.dart';
import 'package:preptime/screens/timer/src/timer_buttons/src/timer_button.dart';
import 'package:preptime/screens/timer/src/timer_buttons/timer_buttons.dart';
import 'package:preptime/screens/timer/src/timer_ring/timer_ring.dart';
import 'package:preptime/screens/timer/timer.dart';

import '../material_wrapper.dart';

void main() {
  group('Timer', () {
    // TODO: #36 Make timer responsive to different screen sized.
    TestWidgetsFlutterBinding binding;
    setUp(() {
      binding = TestWidgetsFlutterBinding.ensureInitialized();
      binding.window.physicalSizeTestValue = Size(300, 800);
      binding.window.devicePixelRatioTestValue = 1.0;
    });
    testWidgets(
      'builds a TimerRing, TimerButtons (and PrepTimers, for debates).',
      (WidgetTester tester) async {
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
    );

    testWidgets(
      'prompts judge to start prep timers after speech ends on iOS',
      (WidgetTester tester) async {
        await tester.pumpWidget(TestMaterial.minimalWrapper(Timer()));

        // Tap the start button and pump 8 minutes
        final startBtn = verifyVisibleWidgetWithText(MaterialButton, 'Start');
        verifyVisibleWidgetWithText(TimerRing, '08:00.0');
        await tester.press(startBtn);
        await tester.pump(Duration(minutes: 8));
        verifyVisibleWidgetWithText(TimerRing, '08:00.0');
        // Check there is a dialog with yes and no options and then tap no
        // verifyVisibleWidgetOfType(CupertinoAlertDialog);
        // verifyVisibleWidgetWithText(CupertinoDialogAction, 'Yes');
        // final no = verifyVisibleWidgetWithText(CupertinoDialogAction, 'No');
        // await tapAndSettleButtonWithTester(no, tester);
      },
    );

    testWidgets(
      'prompts judge to start prep timers after speech ends on android',
      (WidgetTester tester) async {
        await tester.pumpWidget(TestMaterial.minimalWrapper(
          Timer(),
          platformInfo: const PlatformInfo.android(),
        ));

        // Tap the start button and pump 8 minutes
        final startButton = verifyVisibleWidgetWithText(TimerButton, 'Start');
        await tester.press(startButton);
        await tester.pump(Duration(minutes: 8));
        await tester.pumpAndSettle();

        // Check there is a dialog with yes and no options and thentap no
        verifyVisibleWidgetOfType(AlertDialog);
        verifyVisibleWidgetWithText(TextButton, 'Yes');
        final no = verifyVisibleWidgetWithText(TextButton, 'No');
        await tapAndSettleButtonWithTester(no, tester);
      },
      skip: true,
    );

    testWidgets(
      'automatically moves to next page when speech ends',
      (WidgetTester tester) async {
        await tester.pumpWidget(TestMaterial.minimalWrapper(Timer()));
      },
      skip: true,
    );
  });
}
