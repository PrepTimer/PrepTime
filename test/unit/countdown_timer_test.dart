import 'package:fake_async/fake_async.dart';
import 'package:test/test.dart';
import 'package:preptime/models/countdown_timer.dart';

void main() {
  group('CountDownTimer', () {
    CountDownTimer countDownTimer;
    final Duration _initialDuration = const Duration(minutes: 8);

    /// The [setUp] method is called once before each [test].
    setUp(() {
      countDownTimer = CountDownTimer(_initialDuration);
    });
    test('Start with currentTime equal to initialDuration', () async {
      expect(await countDownTimer.currentTime.first, equals(_initialDuration));
    });
    test('Start with initialDuration equal to constructor parameter.', () {
      expect(countDownTimer.initialDuration, equals(_initialDuration));
    });
    test('Resume() causes the value of currentTime to decrease.', () {
      fakeAsync((async) async {
        /// Start the timer, fast-forward 4 minutes and expect new currentTime.
        countDownTimer.resume();
        async.elapse(Duration(minutes: 4));
        Duration currentTime = await countDownTimer.currentTime.first;
        expect(currentTime, equals(Duration(minutes: 4)));
      });
    });
    test('Resume() disposes the sink when timer runs out.', () {
      fakeAsync((async) {
        countDownTimer.resume();
        async.elapse(_initialDuration);
        // if dispose was called, a second call to resume throws state erorr
        expect(() => countDownTimer.resume(), throwsStateError);
      });
    });
    test('Resume() makes isRunning true and isNotRunning false.', () {
      countDownTimer.resume();
      expect(countDownTimer.isRunning, isTrue);
      expect(countDownTimer.isNotRunning, isFalse);
    });
    test('Stop() makes isRunning false and isNotRunning true.', () {
      countDownTimer.resume();
      countDownTimer.stop();
      expect(countDownTimer.isRunning, isFalse);
      expect(countDownTimer.isNotRunning, isTrue);
    });
    test('Reset() causes the currentTime to equal initialDuration.', () {
      fakeAsync<void>((async) async {
        /// Start the timer, fast-forward 4 minutes and expect new currentTime.
        countDownTimer.resume();
        async.elapse(Duration(minutes: 4));
        Duration currentTime = await countDownTimer.currentTime.first;
        expect(currentTime, equals(Duration(minutes: 4)));

        /// Expect reset to cause the currentTime to equal the initial duration
        countDownTimer.reset();
        expect(currentTime, equals(_initialDuration));
      });
    });
    test('Dispose() makes isRunning false and isNotRunning true.', () {
      countDownTimer.resume();
      countDownTimer.dispose();
      expect(countDownTimer.isRunning, isFalse);
      expect(countDownTimer.isNotRunning, isTrue);
    });
    test('Dispose() closes the sink.', () {
      countDownTimer.resume();
      countDownTimer.dispose();
      expect(() => countDownTimer.resume(), throwsStateError);
      countDownTimer = null; // make safe value for teardown
    });
    tearDown(() {
      countDownTimer?.dispose();
    });
  });
}
