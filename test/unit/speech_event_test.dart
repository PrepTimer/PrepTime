// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:preptime/models/speech.dart';
import 'package:preptime/models/speech_event.dart';

/// A fake placeholder for BuildContext.
class MockBuildContext extends Mock implements BuildContext {}

/// A class that has a method called onSpeechEnd that we can verify when and
/// how many times it is called.
class FakeCallback extends Fake {
  static void onSpeechEnd() {}
}

void main() {
  group('SpeechEvent', () {
    MockBuildContext mockBuildContext = MockBuildContext();
    SpeechEvent speechEvent;
    String _name = 'nameOfSpeechEvent';
    String _description = 'descriptionOfSpeechEvent';
    setUp(() {
      speechEvent = SpeechEvent(
        name: _name,
        description: _description,
        speech: Speech(),
      );
    });
    test('constructor fails assertion if name is null', () {
      expect(
        () => SpeechEvent(
          name: null,
          description: 'description',
          speech: Speech(),
        ),
        throwsAssertionError,
      );
    });
    test('constructor fails assertion if description is null', () {
      expect(
        () => SpeechEvent(
          name: 'name',
          description: null,
          speech: Speech(),
        ),
        throwsAssertionError,
      );
    });
    test('constructor fails assertion if speeches is null', () {
      expect(
        () => SpeechEvent(
          name: 'name',
          description: 'description',
          speech: null,
        ),
        throwsAssertionError,
      );
    });
    test('initController fails assertion if ticker is null', () {
      expect(
        () => speechEvent.initSpeechController(
          null,
          context: mockBuildContext,
        ),
        throwsAssertionError,
      );
    });
    test('initController fails assertion if context is null', () {
      expect(
        () => speechEvent.initSpeechController(
          TestVSync(),
          context: null,
        ),
        throwsAssertionError,
      );
    });
    test('name field equals the value given in the constructor', () {
      expect(speechEvent.name, equals(_name));
    });
    test('description field equals the value given in the constructor', () {
      expect(speechEvent.description, equals(_description));
    });
    test('speech field equals the value given in the constructor', () {
      expect(speechEvent.speech, isA<Speech>());
    });
    test('dispose() makes the speech null', () {
      expect(speechEvent.speech, isNotNull);
      speechEvent.dispose();
      expect(speechEvent.speech, isNull);
      speechEvent = null; // make safe value for tearDown
    });
    group('initController', () {
      setUp(() {
        TestWidgetsFlutterBinding.ensureInitialized();
        speechEvent.initSpeechController(
          TestVSync(),
          context: mockBuildContext,
          onSpeechEnd: FakeCallback.onSpeechEnd,
        );
      });
      test('start makes isRunning true', () {
        expect(speechEvent.isNotRunning, isTrue);
        speechEvent.start();
        expect(speechEvent.isRunning, isTrue);
      });
      test('calling stop makes isNotRunning true', () {
        speechEvent.start();
        speechEvent.stop();
        expect(speechEvent.isNotRunning, isTrue);
      });
      test('calling resume makes isRunning true', () {
        speechEvent.start();
        speechEvent.stop();
        speechEvent.resume();
        expect(speechEvent.isRunning, isTrue);
      });
      test('calling reset makes isNotRunning true', () {
        speechEvent.start();
        speechEvent.stop();
        speechEvent.reset();
        expect(speechEvent.isNotRunning, isTrue);
      });
    });
    tearDown(() {
      speechEvent?.dispose();
    });
  });
}
