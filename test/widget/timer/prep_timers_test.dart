// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:preptime/screens/timer/src/prep_timers/prep_timers.dart';
import 'package:preptime/screens/timer/src/prep_timers/src/prep_timer.dart';
import 'package:preptime/screens/timer/src/prep_timers/src/time_label.dart';

import '../material_wrapper.dart';

void main() {
  testWidgets(
    'PrepTimers builds two PrepTimer widgets.',
    (WidgetTester tester) async {
      // Build the PrepTimers widget.
      await tester.pumpWidget(materialWrapper(PrepTimers()));

      // Verify that it builds two PrepTimer widgets.
      expect(find.byType(PrepTimer), findsNWidgets(2));
    },
  );
  testWidgets(
    'longPressing a PrepTimer resets the prep.',
    (WidgetTester tester) async {
      // Build a PrepTimers widget and find the aff PrepTimer button.
      await tester.pumpWidget(materialWrapper(PrepTimers()));
      final affPrepButton = find.widgetWithText(PrepTimer, 'AFF PREP');

      // Verify that both TimeLabels start with 8:00 of prep
      expect(find.widgetWithText(PrepTimer, '8:00'), findsNWidgets(2));

      await tester.tap(affPrepButton);
      await tester.pump(Duration(minutes: 8));

      // Verify the aff TimeLabel has changed
      expect(find.widgetWithText(PrepTimer, '0:01'), findsOneWidget);

      await tester.longPress(affPrepButton);
      await tester.pumpAndSettle();

      // Verify that the long press caused an alert dialog to show
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
      final confirmReset = find.widgetWithText(CupertinoDialogAction, 'Reset');

      await tester.tap(confirmReset);
      await tester.pumpAndSettle();

      // Verify that a longPress resets the clock.
      expect(find.widgetWithText(PrepTimer, '8:00'), findsNWidgets(2));
    },
  );
}
