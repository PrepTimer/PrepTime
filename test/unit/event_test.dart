// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:preptime/models/event.dart';
import 'package:preptime/models/speech.dart';

import '../material_wrapper.dart';

class MockEvent extends Event {
  MockEvent(String name, String description, Speech speech)
      : super(name: name, description: description, speech: speech);

  @override
  void initSpeechController(
    TickerProvider ticker, {
    BuildContext context,
    void Function(BuildContext) onSpeechEnd,
  }) {
    speech.initController(ticker, context);
  }
}

void main() {
  group('Event', () {
    Event event;
    setUp(() {
      event = MockEvent('name', 'description', Speech());
    });
    test('constructor throws assertion error if name is null', () {
      expect(
        () => MockEvent(null, 'description', Speech()),
        throwsAssertionError,
      );
    });
    test('constructor throws assertion error if description is null', () {
      expect(
        () => MockEvent('name', null, Speech()),
        throwsAssertionError,
      );
    });
    test('constructor throws assertion error if speech is null', () {
      expect(
        () => MockEvent('name', 'description', null),
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
    group('initController', () {
      setUp(() {
        TestWidgetsFlutterBinding.ensureInitialized();
        event.initSpeechController(
          TestVSync(),
          context: TestMaterial.mockBuildContext,
        );
      });
      test('start makes isRunning true', () {
        expect(event.isNotRunning, isTrue);
        event.start();
        expect(event.isRunning, isTrue);
      });
      test('calling stop makes isNotRunning true', () {
        event.start();
        event.stop();
        expect(event.isNotRunning, isTrue);
      });
      test('calling resume makes isRunning true', () {
        event.start();
        event.stop();
        event.resume();
        expect(event.isRunning, isTrue);
      });
      test('calling reset makes isNotRunning true', () {
        event.start();
        event.stop();
        event.reset();
        expect(event.isNotRunning, isTrue);
      });
    });
    tearDown(() {
      event?.dispose();
    });
  });
}
