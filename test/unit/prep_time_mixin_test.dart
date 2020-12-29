// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:preptime/models/speech.dart';
import 'package:preptime/models/team.dart';
import 'package:preptime/models/prep_time_mixin.dart';
import 'package:preptime/models/speech_event.dart';

/// Note: This might be an anti-pattern.
///
/// The [PrepTimeMixin] should really only be defined for [DebateEvents], but
/// technically it can be mixed in on any [Event]. Therefore, to prevent
/// isolate the [PrepTimeMixin] for testing, we will create this
/// [TestPrepTimeMixin] class and then go ahead and not use any of the
/// [SpeechEvent] parts of the parent.
class TestPrepTimeMixin extends SpeechEvent with PrepTimeMixin {
  TestPrepTimeMixin()
      : super(name: 'Test', description: 'Foo', speech: Speech());
}

void main() {
  TestPrepTimeMixin testMixin;
  group('PrepTimeMixin before initPrepTimers is called', () {
    setUp(() {
      testMixin = TestPrepTimeMixin(); // before initPrepTimers is called
    });
    test('initialPrep throws state error', () {
      expect(() => testMixin.initialPrep, throwsStateError);
      expect(() => testMixin.initialPrep, throwsStateError);
    });
    test('remainingPrep throws state error', () {
      expect(() => testMixin.remainingPrep(Team.left), throwsStateError);
      expect(() => testMixin.remainingPrep(Team.right), throwsStateError);
    });
    test('resetPrep throws state error', () {
      expect(() => testMixin.resetPrep(Team.left), throwsStateError);
      expect(() => testMixin.resetPrep(Team.right), throwsStateError);
    });
    test('togglePrep throws state error', () {
      expect(() => testMixin.togglePrep(Team.left), throwsStateError);
      expect(() => testMixin.togglePrep(Team.right), throwsStateError);
    });
    test('stopPrep throws state error', () {
      expect(() => testMixin.stopPrep(Team.left), throwsStateError);
      expect(() => testMixin.stopPrep(Team.right), throwsStateError);
    });
    test('startPrep throws state error', () {
      expect(() => testMixin.startPrep(Team.left), throwsStateError);
      expect(() => testMixin.startPrep(Team.right), throwsStateError);
    });
    test('isOtherRunning throws state error', () {
      expect(() => testMixin.isOtherPrepRunning(Team.left), throwsStateError);
      expect(() => testMixin.isOtherPrepRunning(Team.right), throwsStateError);
    });
    test('isRunning throws state error', () {
      expect(() => testMixin.isPrepRunning(Team.left), throwsStateError);
      expect(() => testMixin.isPrepRunning(Team.right), throwsStateError);
    });
    test('isNotRunning throws state error', () {
      expect(() => testMixin.isPrepNotRunning(Team.left), throwsStateError);
      expect(() => testMixin.isPrepNotRunning(Team.right), throwsStateError);
    });
    test('isAnyRunning throws state error', () {
      expect(() => testMixin.isAnyPrepRunning, throwsStateError);
      expect(() => testMixin.isAnyPrepRunning, throwsStateError);
    });
    test('prepName returns AFF/NEG (useAffNeg = true)', () {
      expect(testMixin.prepName(Team.left), equals('AFF'));
      expect(testMixin.prepName(Team.right), equals('NEG'));
    });
    group('PrepTimeMixin after initPrepTimers is called', () {
      setUp(() {
        testMixin = TestPrepTimeMixin();
        testMixin.initPrepTimers(
          duration: const Duration(minutes: 3),
          useAffNeg: false,
        );
      });
      test('initPrepTimers fails assertion if duration is null', () {
        expect(
          () => testMixin.initPrepTimers(duration: null),
          throwsAssertionError,
        );
      });
      test('initialPrep equals value of constructed duration', () {
        expect(testMixin.initialPrep, equals(const Duration(minutes: 3)));
      });
      test('initTimers constructs timers for each team', () {
        expect(testMixin.remainingPrep(Team.left), isNotNull);
        expect(testMixin.remainingPrep(Team.right), isNotNull);
      });
      test('resetPrep sets the amount of prep to initial value', () {
        fakeAsync((async) async {
          // Start a prep timer and then fast-forward a couple of minutes
          Duration _fastForwardDuration = Duration(minutes: 2);
          testMixin.startPrep(Team.left);
          async.elapse(_fastForwardDuration);
          // Verify that the prep timer was actually fast-forwarded
          expect(
            await testMixin.remainingPrep(Team.left).last,
            equals(testMixin.initialPrep - _fastForwardDuration),
          );
          // Reset the prep timer and verify the timer has reset
          testMixin.resetPrep(Team.left);
          expect(
            testMixin.remainingPrep(Team.left),
            equals(testMixin.initialPrep),
          );
        });
      });
      test('isOutOfPrep is true when the prep timer is zero', () {
        fakeAsync((async) async {
          // Start a prep timer and then fast-forward to the end
          Duration _fastForwardDuration = testMixin.initialPrep;
          testMixin.startPrep(Team.left);
          async.elapse(_fastForwardDuration);
          // Verify that the prep timer was actually fast-forwarded
          expect(
            await testMixin.remainingPrep(Team.left).last,
            equals(testMixin.initialPrep - _fastForwardDuration),
          );
          // Verify isOutOfPrep returns true
          expect(testMixin.isOutOfPrep(Team.left), isTrue);
        });
      });
      test('togglePrep starts a timer that is paused', () {
        expect(testMixin.isAnyPrepRunning, isFalse);
        testMixin.togglePrep(Team.left); // starts the prep timer
        expect(testMixin.isAnyPrepRunning, isTrue);
      });
      test('togglePrep stops a timer that is running', () {
        testMixin.startPrep(Team.left); // start with the prep timer running
        expect(testMixin.isAnyPrepRunning, isTrue);
        testMixin.togglePrep(Team.left); // stops the prep timer
        expect(testMixin.isAnyPrepRunning, isFalse);
      });
      test('stopPrep stops a running timer', () {
        testMixin.startPrep(Team.left); // start with the prep timer running
        expect(testMixin.isAnyPrepRunning, isTrue);
        testMixin.stopPrep(Team.left); // stops the prep timer
        expect(testMixin.isAnyPrepRunning, isFalse);
      });
      test('startPrep starts a running timer', () {
        expect(testMixin.isAnyPrepRunning, isFalse);
        testMixin.startPrep(Team.left); // start with the prep timer running
        expect(testMixin.isAnyPrepRunning, isTrue);
      });
      test('isOtherRunning returns the run status of the other timer', () {
        expect(testMixin.isAnyPrepRunning, isFalse);
        testMixin.startPrep(Team.left);
        expect(testMixin.isOtherPrepRunning(Team.right), isTrue);
        expect(testMixin.isOtherPrepRunning(Team.left), isFalse);
      });
      test('isRunning returns the run state of the given timer', () {
        expect(testMixin.isPrepRunning(Team.left), isFalse);
        expect(testMixin.isPrepRunning(Team.right), isFalse);
        testMixin.startPrep(Team.left); // only turn on one timer and check
        expect(testMixin.isPrepRunning(Team.left), isTrue);
        expect(testMixin.isPrepRunning(Team.right), isFalse);
      });
      test('isNotRunning returns the negated run state of the given timer', () {
        expect(testMixin.isPrepNotRunning(Team.left), isTrue);
        expect(testMixin.isPrepNotRunning(Team.right), isTrue);
        testMixin.startPrep(Team.left); // only turn on one timer and check
        expect(testMixin.isPrepNotRunning(Team.left), isFalse);
        expect(testMixin.isPrepNotRunning(Team.right), isTrue);
      });
      test('isAnyRunning returns true if the prep for any team is running', () {
        expect(testMixin.isAnyPrepRunning, isFalse);
        testMixin.startPrep(Team.left); // only turn on one timer and check
        expect(testMixin.isAnyPrepRunning, isTrue);
      });
      test('prepName returns PRO/CON (useAffNeg = false)', () {
        expect(testMixin.prepName(Team.left), equals('PRO'));
        expect(testMixin.prepName(Team.right), equals('CON'));
      });
    });
    tearDown(() {
      testMixin.disposePrepTimers();
    });
  });
}
