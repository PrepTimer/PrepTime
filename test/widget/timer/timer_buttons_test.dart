// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

import 'package:flutter_test/flutter_test.dart';
import 'package:preptime/screens/timer/src/timer_buttons/src/timer_button.dart';
import 'package:preptime/screens/timer/src/timer_buttons/timer_buttons.dart';

import '../../material_wrapper.dart';

main() {
  group('Timer Buttons', () {
    testWidgets(
      'TimerButtons builds two TimerButton widgets',
      (WidgetTester tester) async {
        await tester.pumpWidget(TestMaterial.wrapper(TimerButtons()));
        expect(find.byType(TimerButton), findsNWidgets(2));
      },
    );
    testWidgets(
      'cancel button says cancel for every speech status',
      (WidgetTester tester) async {
        await tester.pumpWidget(TestMaterial.wrapper(TimerButtons()));

        // There should be a cancel button when the timer stopped at beginning.
        final cancelButton = find.widgetWithText(TimerButton, 'Cancel');
        expect(cancelButton, findsOneWidget); // stopped at beginning

        // There should be a cancel button when the timer is running.
        final startButton = find.widgetWithText(TimerButton, 'Start');
        expect(startButton, findsOneWidget);
        await tester.tap(startButton);
        await tester.pumpAndSettle();
        expect(cancelButton, findsOneWidget); // running forward

        // There should be a cancel button when the timer is paused.
        final pauseButton = find.widgetWithText(TimerButton, 'Pause');
        expect(pauseButton, findsOneWidget);
        await tester.tap(pauseButton);
        await tester.pumpAndSettle();
        expect(cancelButton, findsOneWidget);

        // There should be a cancel button when the timer is finished.
        await tester.pump(TestMaterial.speechDuration);
        expect(cancelButton, findsOneWidget);
      },
    );
    testWidgets(
      'start button says Pause for status.pausedInMiddle and Start otherwise',
      (WidgetTester tester) async {
        await tester.pumpWidget(TestMaterial.wrapper(TimerButtons()));
      },
      skip: true,
    );
    testWidgets(
      'both buttons get darked when you press them',
      (WidgetTester tester) async {
        await tester.pumpWidget(TestMaterial.wrapper(TimerButtons()));
      },
      skip: true,
    );
  });
}
