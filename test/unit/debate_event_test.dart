// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

// import 'package:fake_async/fake_async.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:preptime/models/debate_event.dart';
import 'package:preptime/models/speech.dart';
// import 'package:preptime/models/speech_status.dart';
import 'package:preptime/utilities/debate_events/debate_events.dart';

/// A fake placeholder for BuildContext.
class MockBuildContext extends Mock implements BuildContext {}

class SpeechEndCallback {
  void onSpeechEnd() {}
}

/// Verifies how many times onSpeechEnd has been called.
class MockCallback extends Mock implements SpeechEndCallback {}

void main() {
  group('DebateEvent', () {
    MockBuildContext mockContext;
    MockCallback mockCallback;
    DebateEvent debateEvent;
    setUp(() {
      mockContext = MockBuildContext();
      debateEvent = Policy.highSchool();
    });
    test('the debateEvent == operator works as expected', () {
      expect(debateEvent == Policy.highSchool(), isTrue);
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
    test('initController fails assertion if ticker is null', () {
      expect(
        () => debateEvent.initSpeechController(
          null,
          context: mockContext,
        ),
        throwsAssertionError,
      );
    });
    test('initController fails assertion if context is null', () {
      expect(
        () => debateEvent.initSpeechController(
          TestVSync(),
          context: null,
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
        mockCallback = MockCallback();
        debateEvent = Policy.highSchool()
          ..initSpeechController(
            TestVSync(),
            context: mockContext,
            onSpeechEnd: mockCallback.onSpeechEnd,
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
      test('the callback is called when the speech ends', () {
        fakeAsync((async) {
          Speech speech = debateEvent.speech;
          Duration currentTime;
          speech.currentTime.listen((duration) {
            currentTime = duration;
          });
          debateEvent.start();
          async.elapse(speech.length);
          expect(currentTime, Duration.zero);
          expect(speech.isAnimationCompleted(speech.controller.status), isTrue);
          verify(mockCallback.onSpeechEnd()).called(1);
        });
      });
      tearDown(() {
        debateEvent?.dispose();
        debateEvent = null;
      });
    });
    tearDown(() {
      debateEvent?.dispose();
    });
  });
}
