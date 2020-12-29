// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

import 'package:fake_async/fake_async.dart';
import 'package:test/test.dart';
import 'package:preptime/models/simple_timer.dart';

void main() {
  group('SimpleTimer', () {
    SimpleTimer simpleTimer;
    final Duration _initialDuration = const Duration(minutes: 8);

    /// The [setUp] method is called once before each [test].
    setUp(() {
      simpleTimer = SimpleTimer(_initialDuration);
    });
    test('Start with currentTime equal to initialDuration', () async {
      expect(await simpleTimer.currentTime.first, equals(_initialDuration));
    });
    test('Start with initialDuration equal to constructor parameter.', () {
      expect(simpleTimer.initialDuration, equals(_initialDuration));
    });
    test('Resume() causes the value of currentTime to decrease.', () {
      fakeAsync((async) async {
        /// Start the timer, fast-forward 4 minutes and expect new currentTime.
        simpleTimer.resume();
        async.elapse(Duration(minutes: 4));
        Duration currentTime = await simpleTimer.currentTime.first;
        expect(currentTime, equals(Duration(minutes: 4)));
      });
    });
    test('Resume() makes isRunning true and isNotRunning false.', () {
      simpleTimer.resume();
      expect(simpleTimer.isRunning, isTrue);
      expect(simpleTimer.isNotRunning, isFalse);
    });
    test('Stop() makes isRunning false and isNotRunning true.', () {
      simpleTimer.resume();
      simpleTimer.stop();
      expect(simpleTimer.isRunning, isFalse);
      expect(simpleTimer.isNotRunning, isTrue);
    });
    test('Reset() causes the currentTime to equal initialDuration.', () {
      fakeAsync((async) async {
        /// Start the timer, fast-forward 4 minutes and expect new currentTime.
        simpleTimer.resume();
        async.elapse(Duration(minutes: 4));
        Duration currentTime = await simpleTimer.currentTime.first;
        expect(currentTime, equals(Duration(minutes: 4)));

        /// Expect reset to cause the currentTime to equal the initial duration
        simpleTimer.reset();
        expect(currentTime, equals(_initialDuration));
      });
    });
    test('Dispose() makes isRunning false and isNotRunning true.', () {
      simpleTimer.resume();
      simpleTimer.dispose();
      expect(simpleTimer.isRunning, isFalse);
      expect(simpleTimer.isNotRunning, isTrue);
    });
    test('Dispose() closes the sink.', () {
      simpleTimer.resume();
      simpleTimer.dispose();
      expect(() => simpleTimer.resume(), throwsStateError);
      simpleTimer = null; // make safe value for teardown
    });
    tearDown(() {
      simpleTimer?.dispose();
    });
  });
}
