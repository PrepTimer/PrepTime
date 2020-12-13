import 'package:flutter_test/flutter_test.dart';
import 'package:preptime/models/speech.dart';
import 'package:preptime/models/speech_status.dart';

void main() {
  group('Speech', () {
    Speech speech;
    setUp(() {
      speech = Speech();
    });
    test('name equals the given name', () {
      expect(speech.name, equals(Speech().name));
    });
    test('length equals the given duration', () {
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
      speech = Speech(); // setup the speech again for the tearDown step
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
    test('timeRemaining throws StateError without initController call', () {
      expect(() => speech.timeRemaining, throwsStateError);
    });
    test('isRunning throws StateError without initController call', () {
      expect(() => speech.isRunning, throwsStateError);
    });
    test('isNotRunning throws StateError without initController call', () {
      expect(() => speech.isNotRunning, throwsStateError);
    });
    tearDown(() {
      speech.dispose();
    });
  });

  group('MockSpeech', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    Speech speech;
    setUp(() {
      speech = Speech()..initController(const TestVSync());
    });
    test('status is pausedInMiddle after pressing start then stop', () {
      speech.start();
      speech.stop();
      expect(speech.status, equals(SpeechStatus.pausedInMiddle));
    });
    test('status is completed after finishing at the end', () {
      speech.start();
      speech.controller.value = 0.0;
      expect(speech.status, equals(SpeechStatus.completed));
    });
    test('reset sets the timer back to the initial value', () {
      speech.start();
      speech.controller.value = 0.5;
      speech.reset();
      expect(speech.timeRemaining, equals(const Duration(minutes: 8)));
    });
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
      expect(speech.timeRemaining, equals(const Duration(minutes: 4)));
      expect(speech.isRunning, isTrue);
    });
    test('start makes the timer tick forward', () {
      speech.start();
      expect(speech.status, equals(SpeechStatus.runningForward));
    });
    test('timeRemaining returns a duration', () {
      expect(speech.timeRemaining, isA<Duration>());
    });
    test('isRunning is true after start', () {
      speech.start();
      expect(speech.isRunning, isTrue);
    });
    test('isRunning is false after stop', () {
      speech.stop();
      expect(speech.isRunning, isFalse);
    });
    test('isNotRunning is false after start', () {
      speech.start();
      expect(speech.isNotRunning, isFalse);
    });
    test('isNotRunning is true after stop', () {
      speech.stop();
      expect(speech.isNotRunning, isTrue);
    });
    tearDown(() {
      speech.dispose();
    });
  });
}
