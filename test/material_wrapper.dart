// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:preptime/models/event.dart';
import 'package:preptime/models/platform_info.dart';
import 'package:preptime/models/speech.dart';
import 'package:preptime/models/speech_event.dart';
import 'package:preptime/theme/style.dart';
import 'package:preptime/utilities/debate_events/debate_events.dart';
import 'widget/test_provider.dart';

class MockBuildContext extends Mock implements BuildContext {}

/// Testing utilties for testing MaterialApp widgets.
class TestMaterial {
  static BuildContext get mockBuildContext => MockBuildContext();
  static Duration get speechDuration => Duration(minutes: 8);
  static Duration get prepDuration => Duration(minutes: 8);

  /// Wraps the given widget in a MaterialApp and TestProvider.
  ///
  /// To wrap the widget in a MaterialApp and TestProvider, Scaffold, and a
  /// Safe Area, use [wrapper].
  static Widget minimalWrapper(
    Widget child, {
    PlatformInfo platformInfo = const PlatformInfo.iOS(),
    List<Event> events,
  }) {
    _verifyEventsNotNull(events);
    return MaterialApp(
      theme: PrepTimeThemeData.darkTheme,
      title: 'Prep Time',
      home: TestProvider(
        platform: platformInfo,
        events: events,
        child: child,
      ),
    );
  }

  /// Wraps the given widget in a MaterialApp, TestProvider, Scaffold, and a
  /// Safe Area.
  ///
  /// To only wrap the widget in a MaterialApp and TestProvider, use
  /// [minimalWrapper].
  static Widget wrapper(
    Widget child, {
    PlatformInfo platformInfo = const PlatformInfo.iOS(),
    List<Event> events,
  }) {
    _verifyEventsNotNull(events);
    return minimalWrapper(
      Scaffold(
        backgroundColor: PrepTimeThemeData.darkTheme.backgroundColor,
        body: SafeArea(
          child: child,
        ),
      ),
      platformInfo: platformInfo,
      events: events,
    );
  }

  static void _verifyEventsNotNull(List<Event> events) {
    if (events == null) {
      events = [
        Policy.highSchool(),
        SpeechEvent(
          name: 'Extemporaneous',
          description: 'NSDA',
          speech: Speech(),
        ),
      ];
    }
  }
}

/// Verifies that there is a visible (num) widget(s) of the given type.
///
/// The given type must be a subclass of the Widget class, which is to say you
/// must pass a valid widget type as a parameter.
///
/// Returns the finder of the given type.
///
/// ### Implementation:
///
/// ```dart
///   final widgetFinder = find.byType(type);
///   expect(widgetFinder, findsOneWidget);
/// ```
Finder verifyVisibleWidgetOfType(Type type, {int finds = 1}) {
  final widgetFinder = find.byType(type);
  expect(widgetFinder, findsNWidgets(finds));
  return widgetFinder;
}

/// Verifies there is a single widget with the given text as a ancestor.
///
/// ### Implementation:
/// ```dart
///   final widgetFinder = find.widgetWithText(type, text);
///   expect(widgetFinder, findsNWidgets(finds));
///   return widgetFinder;
/// ```
Finder verifyVisibleWidgetWithText(Type type, String text, {int finds = 1}) {
  assert(text?.isNotEmpty ?? false);
  final widgetFinder = find.widgetWithText(type, text);
  expect(widgetFinder, findsNWidgets(finds));
  return widgetFinder;
}

/// Asychronously taps the button and then pumps and settles it.
Future<void> tapAndSettleButtonWithTester(
  Finder button,
  WidgetTester tester,
) async {
  await tester.tap(button);
  await tester.pumpAndSettle();
}

/// Asychronously taps the button and then pumps and settles it.
Future<void> longPressAndSettleButtonWithTester(
  Finder button,
  WidgetTester tester,
) async {
  await tester.longPress(button);
  await tester.pumpAndSettle();
}
