// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:preptime/models/speech.dart';
import 'package:preptime/models/speech_event.dart';
import 'package:preptime/screens/timer/src/timer_ring/src/clock_carousel.dart';
import 'package:preptime/screens/timer/src/timer_ring/src/ring_painter.dart';
import 'package:preptime/screens/timer/src/timer_ring/src/speech_indicator.dart';
import 'package:preptime/screens/timer/src/timer_ring/src/speech_label.dart';
import 'package:preptime/screens/timer/src/timer_ring/timer_ring.dart';

import '../../material_wrapper.dart';

main() {
  group('TimerRing', () {
    testWidgets(
      'builds a RingPainter, ClockCarousel, and SpeechLabel.',
      (WidgetTester tester) async {
        await tester.pumpWidget(TestMaterial.wrapper(TimerRing()));
        verifyVisibleWidgetOfType(RingPainter);
        verifyVisibleWidgetOfType(ClockCarousel);
        verifyVisibleWidgetOfType(SpeechLabel);
      },
    );
    testWidgets(
      'builds SpeechIndicator for debates but not speech events.',
      (WidgetTester tester) async {
        /// Test for DebateEvent
        await tester.pumpWidget(TestMaterial.wrapper(TimerRing()));
        verifyVisibleWidgetOfType(SpeechIndicator);

        /// Test for SpeechEvent
        await tester.pumpWidget(TestMaterial.wrapper(
          TimerRing(),
          events: [
            SpeechEvent(
              name: 'speech',
              description: 'NSDA',
              speech: Speech(),
            )
          ],
        ));
        verifyVisibleWidgetOfType(SpeechIndicator, finds: 0);
      },
    );
    testWidgets(
      'is swipeable to the next speech on TimerRing.',
      (WidgetTester tester) async {
        await tester.pumpWidget(TestMaterial.wrapper(TimerRing()));
        final pageView = verifyVisibleWidgetOfType(PageView);

        /// Verify the first speech is visible.
        verifyVisibleWidgetWithText(SpeechLabel, '1AC');

        // Swipe left
        await tester.fling(pageView, Offset(-200, 0), 1000.0);
        await tester.pumpAndSettle();

        /// Verify the second speech is visible.
        verifyVisibleWidgetWithText(SpeechLabel, 'CX');

        // Swipe right
        await tester.fling(pageView, Offset(200, 0), 1000.0);
        await tester.pumpAndSettle();

        // Verify the first speech is visible
        verifyVisibleWidgetWithText(SpeechLabel, '1AC');
      },
    );
    testWidgets(
      'does not let you swipe past the end.',
      (WidgetTester tester) async {
        await tester.pumpWidget(TestMaterial.wrapper(TimerRing()));
        final pageView = verifyVisibleWidgetOfType(PageView);

        /// Verify first speech visible and swipe until the last speech visible
        verifyVisibleWidgetWithText(SpeechLabel, '1AC');

        for (int i = 0; i < 12; i++) {
          await tester.fling(pageView, Offset(-200, 0), 1000.0);
          await tester.pumpAndSettle();
        }

        /// Verify the last speech is visible
        verifyVisibleWidgetWithText(SpeechLabel, '2AR');

        /// fling again and verify the last speech is still visible
        await tester.fling(pageView, Offset(-200, 0), 1000.0);
        await tester.pumpAndSettle();
        verifyVisibleWidgetWithText(SpeechLabel, '2AR');
      },
    );
  });
}
