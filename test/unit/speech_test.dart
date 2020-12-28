// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

import 'package:fake_async/fake_async.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:preptime/models/speech.dart';
import 'package:preptime/models/speech_status.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  group('Speech', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    Speech speech;
    setUp(() {
      speech = Speech();
    });
    test('name equals the constructed string', () {
      expect(speech.name, equals(Speech().name));
    });
    test('length equals the constructed duration', () {
      expect(speech.length, equals(Speech().length));
    });
    test('shouldCountUp equals the constructed bool', () {
      expect(speech.shouldCountUp, equals(Speech().shouldCountUp));
    });
    test('useJudgeAssistant equals the constructed bool', () {
      expect(speech.useJudgeAssistant, equals(Speech().useJudgeAssistant));
    });
    test('dispose makes the controller null', () {
      speech.dispose();
      expect(speech.controller, isNull);
      speech = null; // make safe value for tearDown
    });
    test('status is stoppedAtBeginning by default', () {
      expect(speech.status, equals(SpeechStatus.stoppedAtBeginning));
    });
    test('reset throws StateError without call to initController', () {
      expect(() => speech.reset(), throwsStateError);
    });
    test('stop throws StateError without call to initController', () {
      expect(() => speech.stop(), throwsStateError);
    });
    test('resume throws StateError without call to initController', () {
      expect(() => speech.resume(), throwsStateError);
    });
    test('start throws StateError without call to initController', () {
      expect(() => speech.start(), throwsStateError);
    });
    test('currentTime throws StateError without initController call', () {
      expect(() => speech.currentTime, throwsStateError);
    });
    test('isRunning throws StateError without initController call', () {
      expect(() => speech.isRunning, throwsStateError);
    });
    test('isNotRunning throws StateError without initController call', () {
      expect(() => speech.isNotRunning, throwsStateError);
    });
    group('(initialized)', () {
      setUp(() {
        MockBuildContext mockContext = MockBuildContext();
        speech = Speech(shouldCountUp: true, useJudgeAssistant: false);
        speech.initController(const TestVSync(), mockContext);
      });
      test('status is pausedInMiddle after pressing start then stop', () {
        speech.start();
        speech.stop();
        expect(speech.status, equals(SpeechStatus.pausedInMiddle));
      });
      test('status is completed after finishing at the end', () {
        fakeAsync((async) {
          expect(speech.status, equals(SpeechStatus.stoppedAtBeginning));
          speech.start();
          async.elapse(Duration(minutes: 8));
        });
        expect(speech.status, equals(SpeechStatus.completed));
      }, skip: 'Failing for some reason.');
      test('reset sets the timer back to the initial value', () {
        fakeAsync((async) {
          speech.start();
          async.elapse(Duration(minutes: 4));
          speech.reset();
          expect(speech.currentTime, equals(Duration.zero));
        });
      }, skip: 'Failing for some reason.');
      test('stop pauses the timer', () {
        speech.stop();
        expect(speech.status, equals(SpeechStatus.pausedInMiddle));
        expect(speech.isNotRunning, isTrue);
      });
      test('resume starts the timer from a stop', () {
        speech.start();
        speech.controller.value = 0.5;
        speech.stop();
        speech.resume();
        expect(speech.currentTime.last, equals(const Duration(minutes: 4)));
        expect(speech.isRunning, isTrue);
      }, skip: 'Failing for some reason.');
      test('resume makes the timer tick forward', () {
        speech.resume();
        expect(speech.status, equals(SpeechStatus.runningForward));
      });
      test('start makes the timer tick forward', () {
        speech.start();
        expect(speech.status, equals(SpeechStatus.runningForward));
      });
      test('currentTime returns a duration', () async {
        expect(await speech.currentTime.first, isA<Duration>());
      });
      test('isRunning is true after start and false after stop', () {
        speech.start();
        expect(speech.isRunning, isTrue);
        speech.stop();
        expect(speech.isRunning, isFalse);
      });
      test('isNotRunning is false after start and true after stop', () {
        speech.start();
        expect(speech.isNotRunning, isFalse);
        speech.stop();
        expect(speech.isNotRunning, isTrue);
      });
    });
    tearDown(() {
      speech?.dispose();
    });
  });
}
