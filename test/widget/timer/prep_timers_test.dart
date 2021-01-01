// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:preptime/models/platform_info.dart';
import 'package:preptime/screens/timer/src/prep_timers/prep_timers.dart';
import 'package:preptime/screens/timer/src/prep_timers/src/prep_timer.dart';

import '../../material_wrapper.dart';

void main() {
  testWidgets(
    'PrepTimers builds two PrepTimer widgets.',
    (WidgetTester tester) async {
      await tester.pumpWidget(TestMaterial.wrapper(PrepTimers()));
      verifyVisibleWidgetOfType(PrepTimer, finds: 2);
    },
  );
  testWidgets(
    'longPressing a PrepTimer resets the prep on iOS.',
    (WidgetTester tester) async {
      // Build a PrepTimers widget and find the aff PrepTimer button.
      await tester.pumpWidget(TestMaterial.wrapper(PrepTimers()));
      final affPrepButton = find.widgetWithText(PrepTimer, 'AFF PREP');
      expect(affPrepButton, findsOneWidget);

      // Verify that both TimeLabels start with 8:00 of prep
      expect(find.widgetWithText(PrepTimer, '8:00'), findsNWidgets(2));

      await tester.tap(affPrepButton);
      await tester.pump(Duration(minutes: 8));

      // Verify the aff TimeLabel has changed
      /// TODO: #35 Fix 0:01 bug
      expect(find.widgetWithText(PrepTimer, '0:01'), findsOneWidget);

      await longPressAndSettleButtonWithTester(affPrepButton, tester);

      // Verify that the long press caused an alert dialog to show
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
      final cancel = find.widgetWithText(CupertinoDialogAction, 'Cancel');
      expect(cancel, findsOneWidget);

      await tapAndSettleButtonWithTester(cancel, tester);

      // Verify the prep time was not reset
      expect(find.widgetWithText(PrepTimer, '0:01'), findsOneWidget);

      await longPressAndSettleButtonWithTester(affPrepButton, tester);

      // Verify that the long press caused an alert dialog to show
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
      final reset = find.widgetWithText(CupertinoDialogAction, 'Reset');
      expect(reset, findsOneWidget);

      await tapAndSettleButtonWithTester(reset, tester);

      // Verify that a longPress resets the clock.
      expect(find.widgetWithText(PrepTimer, '8:00'), findsNWidgets(2));
    },
  );
  testWidgets(
    'longPressing a PrepTimer resets the prep on Android.',
    (WidgetTester tester) async {
      // Build a PrepTimers widget and find the aff PrepTimer button.
      await tester.pumpWidget(TestMaterial.wrapper(
        PrepTimers(),
        platformInfo: PlatformInfo.android(),
      ));
      verifyVisibleWidgetWithText(PrepTimer, '8:00', finds: 2);

      // Tap the aff prep button
      final affPrepButton = verifyVisibleWidgetWithText(PrepTimer, 'AFF PREP');
      await tester.tap(affPrepButton);
      await tester.pump(Duration(minutes: 8));

      verifyVisibleWidgetWithText(PrepTimer, '0:01', finds: 1);
      await longPressAndSettleButtonWithTester(affPrepButton, tester);

      verifyVisibleWidgetOfType(AlertDialog);
      final cancel = verifyVisibleWidgetWithText(TextButton, 'Cancel');
      await tapAndSettleButtonWithTester(cancel, tester);

      verifyVisibleWidgetWithText(PrepTimer, '0:01');
      await longPressAndSettleButtonWithTester(affPrepButton, tester);

      verifyVisibleWidgetOfType(AlertDialog);
      final reset = verifyVisibleWidgetWithText(TextButton, 'Reset');
      await tapAndSettleButtonWithTester(reset, tester);

      verifyVisibleWidgetWithText(PrepTimer, '8:00', finds: 2);
    },
  );
}
