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
    // test('stop pauses the timer', () {}, skip: 'Test SpeechStatus');
    // test('resume starts the timer from a stop', () {},
    //     skip: 'Test SpeechStatus');
    // test('start makes the timer tick forward', () {},
    //     skip: 'Test SpeechStatus');
    // test('timeRemaining returns a string representation of the clock', () {},
    //     skip: 'Test SpeechStatus');
    // test('isRunning is true after start and false after stop', () {},
    //     skip: 'Test SpeechStatus');
    // test('isNotRunning is true after stop and false after start', () {},
    //     skip: 'Test SpeechStatus');
    tearDown(() {
      speech.dispose();
    });
  });
}
