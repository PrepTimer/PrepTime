// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:preptime/models/debate_event.dart';
import 'package:preptime/models/platform_info.dart';
import 'package:preptime/models/speech.dart';
import 'package:preptime/models/speech_event.dart';
import 'package:preptime/screens/timer/src/prep_timers/prep_timers.dart';
import 'package:preptime/screens/timer/src/prep_timers/src/prep_timer.dart';
import 'package:preptime/screens/timer/src/timer_buttons/src/timer_button.dart';
import 'package:preptime/screens/timer/src/timer_buttons/timer_buttons.dart';
import 'package:preptime/screens/timer/src/timer_ring/src/clock_label.dart';
import 'package:preptime/screens/timer/src/timer_ring/src/speech_label.dart';
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
      'automatically moves to next page when speech ends',
      (WidgetTester tester) async {
        await tester.pumpWidget(TestMaterial.minimalWrapper(Timer()));
        final pageView = verifyVisibleWidgetOfType(PageView);

        /// Verify first speech visible and swipe until the last speech visible
        verifyVisibleWidgetWithText(SpeechLabel, '1AC');

        /// fling again and verify the last speech is still visible
        await tester.fling(pageView, Offset(-200, 0), 1000.0);
        await tester.pumpAndSettle();
        verifyVisibleWidgetWithText(SpeechLabel, 'CX');
      },
    );
    testWidgets(
      'resets after the last speech ends',
      (WidgetTester tester) async {
        await tester.pumpWidget(TestMaterial.minimalWrapper(Timer()));
        final pageView = verifyVisibleWidgetOfType(PageView);

        /// Verify first speech visible and swipe until the last speech visible
        verifyVisibleWidgetWithText(SpeechLabel, '1AC');

        for (int i = 0; i < 12; i++) {
          await tester.fling(pageView, Offset(-200, 0), 1000.0);
          await tester.pumpAndSettle();
        }

        /// Verify the last speech is visible
        verifyVisibleWidgetWithText(SpeechLabel, '2AR');

        /// start timer and hope it all works.
        final startButton = verifyVisibleWidgetWithText(TimerButton, 'Start');
        await tester.tap(startButton);
        await tester.pump();
        await tester.pump(Duration(minutes: 5));
        verifyVisibleWidgetWithText(ClockLabel, '05:00.0');
      },
    );
    testWidgets(
      'shows time signals at 5, 4, 3, 2, and 1 min/sec left plus 30, 15 sec',
      (WidgetTester tester) async {
        await tester.pumpWidget(TestMaterial.minimalWrapper(
          Timer(),
          events: [
            DebateEvent(
              name: 'name',
              description: 'NSDA',
              speeches: [
                Speech(
                  showTimeSignals: true,
                  useJudgeAssistant: false,
                ),
              ],
            )..initPrepTimers(duration: Duration(minutes: 5)),
          ],
        ));
        // Tap the start button and pump 8 minutes
        final startBtn = verifyVisibleWidgetWithText(TimerButton, 'Start');
        await tester.tap(startBtn);
        await tester.pump(); // pump once to update stateful widget

        await tester.pump(Duration(minutes: 3));
        verifyVisibleWidgetWithText(ClockLabel, '05:00.0');
        verifyVisibleWidgetWithText(
          CupertinoPopupSurface,
          'Five Minutes Left',
        );

        await tester.pump(Duration(minutes: 1));
        verifyVisibleWidgetWithText(ClockLabel, '04:00.0');
        verifyVisibleWidgetWithText(
          CupertinoPopupSurface,
          'Four Minutes Left',
        );

        await tester.pump(Duration(minutes: 1));
        verifyVisibleWidgetWithText(ClockLabel, '03:00.0');
        verifyVisibleWidgetWithText(
          CupertinoPopupSurface,
          'Three Minutes Left',
        );

        await tester.pump(Duration(minutes: 1));
        verifyVisibleWidgetWithText(ClockLabel, '02:00.0');
        verifyVisibleWidgetWithText(
          CupertinoPopupSurface,
          'Two Minutes Left',
        );

        await tester.pump(Duration(minutes: 1));
        verifyVisibleWidgetWithText(ClockLabel, '01:00.0');
        verifyVisibleWidgetWithText(
          CupertinoPopupSurface,
          'One Minute Left',
        );

        await tester.pump(Duration(seconds: 30));
        verifyVisibleWidgetWithText(ClockLabel, '00:30.0');
        verifyVisibleWidgetWithText(
          CupertinoPopupSurface,
          'Thirty Seconds Left',
        );

        await tester.pump(Duration(seconds: 15));
        verifyVisibleWidgetWithText(ClockLabel, '00:15.0');
        verifyVisibleWidgetWithText(
          CupertinoPopupSurface,
          'Fifteen Seconds Left',
        );

        await tester.pump(Duration(seconds: 10));
        verifyVisibleWidgetWithText(ClockLabel, '00:05.0');
        verifyVisibleWidgetWithText(
          CupertinoPopupSurface,
          'Five Seconds Left',
        );

        await tester.pump(Duration(seconds: 1));
        verifyVisibleWidgetWithText(ClockLabel, '00:04.0');
        verifyVisibleWidgetWithText(
          CupertinoPopupSurface,
          'Four Seconds Left',
        );

        await tester.pump(Duration(seconds: 1));
        verifyVisibleWidgetWithText(ClockLabel, '00:03.0');
        verifyVisibleWidgetWithText(
          CupertinoPopupSurface,
          'Three Seconds Left',
        );

        await tester.pump(Duration(seconds: 1));
        verifyVisibleWidgetWithText(ClockLabel, '00:02.0');
        verifyVisibleWidgetWithText(
          CupertinoPopupSurface,
          'Two Seconds Left',
        );

        await tester.pump(Duration(seconds: 1));
        verifyVisibleWidgetWithText(ClockLabel, '00:01.0');
        verifyVisibleWidgetWithText(
          CupertinoPopupSurface,
          'One Second Left',
        );

        await tester.pumpAndSettle(); // clears pending timers
      },
    );

    group('[Android]', () {
      testWidgets(
        'prompts judge to start prep timers after speech ends on android',
        (WidgetTester tester) async {
          await tester.pumpWidget(TestMaterial.minimalWrapper(
            Timer(),
            platformInfo: const PlatformInfo.android(),
          ));

          // Tap the start button and pump 8 minutes
          final startButton = verifyVisibleWidgetWithText(TimerButton, 'Start');
          await tester.tap(startButton);
          await tester.pump();
          await tester.pump(Duration(minutes: 8));

          // Check there is a dialog with yes and no options and thentap no
          verifyVisibleWidgetOfType(AlertDialog);
          verifyVisibleWidgetWithText(TextButton, 'Yes');
          final no = verifyVisibleWidgetWithText(TextButton, 'No');
          await tapAndSettleButtonWithTester(no, tester);
        },
      );
      testWidgets(
        'automatically starts the neg prep when you tap yes and then neg',
        (WidgetTester tester) async {
          await tester.pumpWidget(TestMaterial.minimalWrapper(
            Timer(),
            platformInfo: PlatformInfo.android(),
          ));

          // Tap the start button and pump 8 minutes
          final startBtn = verifyVisibleWidgetWithText(TimerButton, 'Start');
          await tester.tap(startBtn);
          await tester.pump(); // pump once to update stateful widget
          await tester.pump(Duration(minutes: 8));

          // Check there is a dialog with yes and no options and then tap yes
          verifyVisibleWidgetOfType(AlertDialog);
          final yes = verifyVisibleWidgetWithText(TextButton, 'Yes');
          await tapAndSettleButtonWithTester(yes, tester);

          // There should be a second action dialog that shows up and click neg
          verifyVisibleWidgetOfType(AlertDialog);
          final neg = verifyVisibleWidgetWithText(TextButton, 'NEG');

          // Verify that the neg prep has started
          verifyVisibleWidgetWithText(PrepTimer, '8:00', finds: 2);
          await tapAndSettleButtonWithTester(neg, tester);
          await tester.pump(Duration(minutes: 4)); // elapse some time
          verifyVisibleWidgetWithText(PrepTimer, '8:00', finds: 1);
        },
      );
      testWidgets(
        'automatically starts the aff prep when you tap yes and then aff',
        (WidgetTester tester) async {
          await tester.pumpWidget(TestMaterial.minimalWrapper(
            Timer(),
            platformInfo: PlatformInfo.android(),
          ));

          // Tap the start button and pump 8 minutes
          final startBtn = verifyVisibleWidgetWithText(TimerButton, 'Start');
          await tester.tap(startBtn);
          await tester.pump(); // pump once to update stateful widget
          await tester.pump(Duration(minutes: 8));

          // Check there is a dialog with yes and no options and then tap yes
          verifyVisibleWidgetOfType(AlertDialog);
          final yes = verifyVisibleWidgetWithText(TextButton, 'Yes');
          await tapAndSettleButtonWithTester(yes, tester);

          // There should be a second action dialog that shows up and click neg
          verifyVisibleWidgetOfType(AlertDialog);
          final aff = verifyVisibleWidgetWithText(TextButton, 'AFF');

          // Verify that the neg prep has started
          verifyVisibleWidgetWithText(PrepTimer, '8:00', finds: 2);
          await tapAndSettleButtonWithTester(aff, tester);
          await tester.pump(Duration(minutes: 4)); // elapse some time
          verifyVisibleWidgetWithText(PrepTimer, '8:00', finds: 1);
        },
      );
    });
    group('[iOS]', () {
      testWidgets(
        'prompts judge to start prep timers after speech ends on iOS',
        (WidgetTester tester) async {
          await tester.pumpWidget(TestMaterial.minimalWrapper(
            Timer(),
            platformInfo: const PlatformInfo.iOS(),
          ));

          // Tap the start button and pump 8 minutes
          final startBtn = verifyVisibleWidgetWithText(TimerButton, 'Start');
          await tester.tap(startBtn);
          await tester.pump(); // pump once to update stateful widget
          await tester.pump(Duration(minutes: 8));

          // Check there is a dialog with yes and no options and then tap no
          verifyVisibleWidgetOfType(CupertinoAlertDialog);
          verifyVisibleWidgetWithText(CupertinoDialogAction, 'Yes');
          final no = verifyVisibleWidgetWithText(CupertinoDialogAction, 'No');
          await tapAndSettleButtonWithTester(no, tester);
        },
      );
      testWidgets(
        'automatically starts the neg prep when you tap yes and then neg',
        (WidgetTester tester) async {
          await tester.pumpWidget(TestMaterial.minimalWrapper(Timer()));

          // Tap the start button and pump 8 minutes
          final startBtn = verifyVisibleWidgetWithText(TimerButton, 'Start');
          await tester.tap(startBtn);
          await tester.pump(); // pump once to update stateful widget
          await tester.pump(Duration(minutes: 8));

          // Check there is a dialog with yes and no options and then tap yes
          verifyVisibleWidgetOfType(CupertinoAlertDialog);
          final yes = verifyVisibleWidgetWithText(CupertinoDialogAction, 'Yes');
          await tapAndSettleButtonWithTester(yes, tester);

          // There should be a second action dialog that shows up and click neg
          verifyVisibleWidgetOfType(CupertinoAlertDialog);
          final neg = verifyVisibleWidgetWithText(CupertinoDialogAction, 'NEG');

          // Verify that the neg prep has started
          verifyVisibleWidgetWithText(PrepTimer, '8:00', finds: 2);
          await tapAndSettleButtonWithTester(neg, tester);
          await tester.pump(Duration(minutes: 4)); // elapse some time
          verifyVisibleWidgetWithText(PrepTimer, '8:00', finds: 1);
        },
      );
      testWidgets(
        'automatically starts the aff prep when you tap yes and then aff',
        (WidgetTester tester) async {
          await tester.pumpWidget(TestMaterial.minimalWrapper(Timer()));

          // Tap the start button and pump 8 minutes
          final startBtn = verifyVisibleWidgetWithText(TimerButton, 'Start');
          await tester.tap(startBtn);
          await tester.pump(); // pump once to update stateful widget
          await tester.pump(Duration(minutes: 8));

          // Check there is a dialog with yes and no options and then tap yes
          verifyVisibleWidgetOfType(CupertinoAlertDialog);
          final yes = verifyVisibleWidgetWithText(CupertinoDialogAction, 'Yes');
          await tapAndSettleButtonWithTester(yes, tester);

          // There should be a second action dialog that shows up and click neg
          verifyVisibleWidgetOfType(CupertinoAlertDialog);
          final aff = verifyVisibleWidgetWithText(CupertinoDialogAction, 'AFF');

          // Verify that the neg prep has started
          verifyVisibleWidgetWithText(PrepTimer, '8:00', finds: 2);
          await tapAndSettleButtonWithTester(aff, tester);
          await tester.pump(Duration(minutes: 4)); // elapse some time
          verifyVisibleWidgetWithText(PrepTimer, '8:00', finds: 1);
        },
      );
    });
  });
}
