// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:preptime/models/event.dart';
import 'package:preptime/models/speech.dart';

class MockEvent extends Event {
  MockEvent(String name, String description, Speech speech)
      : super(name: name, description: description, speech: speech);

  @override
  void initSpeechController(
    TickerProvider ticker, {
    BuildContext context,
    void Function() onSpeechEnd,
  }) {} // must override but we test this elsewhere.
}

void main() {
  group('Event', () {
    Event event;
    setUp(() {
      event = MockEvent('name', 'description', Speech());
    });
    test('constructor throws if name is null', () {
      expect(
        () => MockEvent(null, 'description', Speech()),
        throwsAssertionError,
      );
    });
    test('name field equals the value given in the constructor', () {
      expect(event.name, equals('name'));
    });
    test('description field equals the value given in the constructor', () {
      expect(event.description, equals('description'));
    });
    test('speech field equals the value given in the constructor', () {
      expect(event.speech, isA<Speech>());
    });
    tearDown(() {
      event?.dispose();
    });
  });
}
