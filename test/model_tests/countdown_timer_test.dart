import 'package:fake_async/fake_async.dart';
import 'package:test/test.dart';
import 'package:preptime/provider/models/countdown_timer.dart';

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
    test('Resume() makes isRunning true.', () {
      countDownTimer.resume();
      expect(countDownTimer.isRunning, isTrue);
    });
    test('Resume() makes isNotRunning false.', () {
      countDownTimer.resume();
      expect(countDownTimer.isNotRunning, isFalse);
    });
    test('Stop() makes isRunning false.', () {
      countDownTimer.resume();
      countDownTimer.stop();
      expect(countDownTimer.isRunning, isFalse);
    });
    test('Stop() makes isNotRunning true.', () {
      countDownTimer.resume();
      countDownTimer.stop();
      expect(countDownTimer.isNotRunning, isTrue);
    });
    test('Reset() causes the currentTime to equal initialDuration.', () async {
      fakeAsync((async) async {
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
    test('Dispose() makes isRunning false.', () {
      countDownTimer.resume();
      countDownTimer.dispose();
      expect(countDownTimer.isRunning, isFalse);
    });
    test('Dispose() makes isNotRunning true.', () {
      countDownTimer.resume();
      countDownTimer.dispose();
      expect(countDownTimer.isNotRunning, isTrue);
    });
    test('Dispose() closes the sink.', () {
      countDownTimer.resume();
      countDownTimer.dispose();
      expect(() => countDownTimer.resume(), throwsStateError);
    });

    tearDown(() {
      countDownTimer.dispose();
    });
  });
}
