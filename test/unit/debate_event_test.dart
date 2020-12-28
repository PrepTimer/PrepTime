// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:preptime/models/debate_event.dart';
import 'package:preptime/models/speech.dart';
import 'package:preptime/utilities/debate_events/debate_events.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  group('DebateEvent', () {
    DebateEvent debateEvent;
    setUp(() {
      debateEvent = Policy.highSchool();
    });
    test('constructor fails assertion if name is null', () {
      expect(
        () => DebateEvent(
          name: null,
          description: 'description',
          speeches: [Speech()],
        ),
        throwsAssertionError,
      );
    });
    test('constructor fails assertion if description is null', () {
      expect(
        () => DebateEvent(
          name: 'name',
          description: null,
          speeches: [Speech()],
        ),
        throwsAssertionError,
      );
    });
    test('constructor fails assertion if speeches is null', () {
      expect(
        () => DebateEvent(
          name: 'name',
          description: 'description',
          speeches: null,
        ),
        throwsAssertionError,
      );
    });
    test('getter speeches returns a non-null list of speeches.', () {
      expect(debateEvent.speeches, isNotNull);
      expect(debateEvent.speeches is List<Speech>, isTrue);
    });
    test('nextSpeech() increments the speech index.', () {
      expect(debateEvent.speeches.indexOf(debateEvent.speech), equals(0));
      debateEvent.nextSpeech();
      expect(debateEvent.speeches.indexOf(debateEvent.speech), equals(1));
    });
    test('nextSpeech() throws IndexError on last index.', () {
      for (int i = 0; i < debateEvent.speeches.length - 1; i++) {
        debateEvent.nextSpeech(); // skip through all but the last speech
      }
      expect(() => debateEvent.nextSpeech(), throwsRangeError);
    });
    test('prevSpeech() decrements the speech index.', () {
      debateEvent.nextSpeech(); // to avoid throwing RangeError
      expect(debateEvent.speeches.indexOf(debateEvent.speech), equals(1));
      debateEvent.prevSpeech();
      expect(debateEvent.speeches.indexOf(debateEvent.speech), equals(0));
    });
    test('prevSpeech() throws IndexError on first index.', () {
      expect(() => debateEvent.prevSpeech(), throwsRangeError);
    });
    test('dispose() clears the list of speeches.', () {
      debateEvent.dispose();
      expect(debateEvent.speeches, isEmpty);
      debateEvent = null; // make safe value for teardown
    });
    test('dispose() clears the Event speech.', () {
      debateEvent.dispose();
      expect(debateEvent.speech, isNull);
      debateEvent = null; // make safe value for teardown
    });
    group('initController', () {
      setUp(() {
        TestWidgetsFlutterBinding.ensureInitialized();
        MockBuildContext mockBuildContext = MockBuildContext();
        debateEvent.initSpeechController(
          TestVSync(),
          context: mockBuildContext,
        );
      });
      test('start makes isRunning true', () {
        expect(debateEvent.isNotRunning, isTrue);
        debateEvent.start();
        expect(debateEvent.isRunning, isTrue);
      });
      test('calling stop makes isNotRunning true', () {
        debateEvent.start();
        debateEvent.stop();
        expect(debateEvent.isNotRunning, isTrue);
      });
      test('calling resume makes isRunning true', () {
        debateEvent.start();
        debateEvent.stop();
        debateEvent.resume();
        expect(debateEvent.isRunning, isTrue);
      });
      test('calling reset makes isNotRunning true', () {
        debateEvent.start();
        debateEvent.stop();
        debateEvent.reset();
        expect(debateEvent.isNotRunning, isTrue);
      });
    });
    tearDown(() {
      debateEvent?.dispose();
    });
  });
}
