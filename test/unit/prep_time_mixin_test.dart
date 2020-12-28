// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

import 'package:fake_async/fake_async.dart';
import 'package:preptime/models/speech.dart';
import 'package:preptime/models/team.dart';
import 'package:preptime/models/prep_time_mixin.dart';
import 'package:preptime/models/speech_event.dart';
import 'package:test/test.dart';

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
  TestPrepTimeMixin prepTimeMixin;
  group('PrepTimeMixin before initPrepTimers is called', () {
    setUp(() {
      prepTimeMixin = TestPrepTimeMixin(); // before initPrepTimers is called
    });
    test('initialPrep throws state error', () {
      expect(() => prepTimeMixin.initialPrep, throwsStateError);
      expect(() => prepTimeMixin.initialPrep, throwsStateError);
    });
    test('remainingPrep throws state error', () {
      expect(() => prepTimeMixin.remainingPrep(Team.left), throwsStateError);
      expect(() => prepTimeMixin.remainingPrep(Team.right), throwsStateError);
    });
    test('resetPrep throws state error', () {
      expect(() => prepTimeMixin.resetPrep(Team.left), throwsStateError);
      expect(() => prepTimeMixin.resetPrep(Team.right), throwsStateError);
    });
    test('togglePrep throws state error', () {
      expect(() => prepTimeMixin.togglePrep(Team.left), throwsStateError);
      expect(() => prepTimeMixin.togglePrep(Team.right), throwsStateError);
    });
    test('stopPrep throws state error', () {
      expect(() => prepTimeMixin.stopPrep(Team.left), throwsStateError);
      expect(() => prepTimeMixin.stopPrep(Team.right), throwsStateError);
    });
    test('startPrep throws state error', () {
      expect(() => prepTimeMixin.startPrep(Team.left), throwsStateError);
      expect(() => prepTimeMixin.startPrep(Team.right), throwsStateError);
    });
    test('isOtherRunning throws state error', () {
      expect(
          () => prepTimeMixin.isOtherPrepRunning(Team.left), throwsStateError);
      expect(
          () => prepTimeMixin.isOtherPrepRunning(Team.right), throwsStateError);
    });
    test('isRunning throws state error', () {
      expect(() => prepTimeMixin.isPrepRunning(Team.left), throwsStateError);
      expect(() => prepTimeMixin.isPrepRunning(Team.right), throwsStateError);
    });
    test('isNotRunning throws state error', () {
      expect(() => prepTimeMixin.isPrepNotRunning(Team.left), throwsStateError);
      expect(
          () => prepTimeMixin.isPrepNotRunning(Team.right), throwsStateError);
    });
    test('isAnyRunning throws state error', () {
      expect(() => prepTimeMixin.isAnyPrepRunning, throwsStateError);
      expect(() => prepTimeMixin.isAnyPrepRunning, throwsStateError);
    });
    test('prepName returns AFF/NEG (useAffNeg = true)', () {
      expect(prepTimeMixin.prepName(Team.left), equals('AFF'));
      expect(prepTimeMixin.prepName(Team.right), equals('NEG'));
    });
    tearDown(() {
      prepTimeMixin.disposePrepTimers();
    });
  });
  group('PrepTimeMixin after initPrepTimers is called', () {
    setUp(() {
      prepTimeMixin = TestPrepTimeMixin();
      prepTimeMixin.initPrepTimers(
        duration: const Duration(minutes: 3),
        useAffNeg: false,
      );
    });
    test('initialPrep equals value of constructed duration', () {
      expect(prepTimeMixin.initialPrep, equals(const Duration(minutes: 3)));
    });
    test('initTimers constructs timers for each team', () {
      expect(prepTimeMixin.remainingPrep(Team.left), isNotNull);
      expect(prepTimeMixin.remainingPrep(Team.right), isNotNull);
    });
    test('resetPrep throws state error', () {
      fakeAsync((async) async {
        // Start a prep timer and then fast-forward a couple of minutes
        Duration _fastForwardDuration = Duration(minutes: 2);
        prepTimeMixin.startPrep(Team.left);
        async.elapse(_fastForwardDuration);
        // Verify that the prep timer was actually fast-forwarded
        expect(
          await prepTimeMixin.remainingPrep(Team.left).last,
          equals(prepTimeMixin.initialPrep - _fastForwardDuration),
        );
        // Reset the prep timer and verify the timer has reset
        prepTimeMixin.resetPrep(Team.left);
        expect(
          prepTimeMixin.remainingPrep(Team.left),
          equals(prepTimeMixin.initialPrep),
        );
      });
    });
    test('togglePrep starts a timer that is paused', () {
      expect(prepTimeMixin.isAnyPrepRunning, isFalse);
      prepTimeMixin.togglePrep(Team.left); // starts the prep timer
      expect(prepTimeMixin.isAnyPrepRunning, isTrue);
    });
    test('togglePrep stops a timer that is running', () {
      prepTimeMixin.startPrep(Team.left); // start with the prep timer running
      expect(prepTimeMixin.isAnyPrepRunning, isTrue);
      prepTimeMixin.togglePrep(Team.left); // stops the prep timer
      expect(prepTimeMixin.isAnyPrepRunning, isFalse);
    });
    test('stopPrep stops a running timer', () {
      prepTimeMixin.startPrep(Team.left); // start with the prep timer running
      expect(prepTimeMixin.isAnyPrepRunning, isTrue);
      prepTimeMixin.stopPrep(Team.left); // stops the prep timer
      expect(prepTimeMixin.isAnyPrepRunning, isFalse);
    });
    test('startPrep starts a running timer', () {
      expect(prepTimeMixin.isAnyPrepRunning, isFalse);
      prepTimeMixin.startPrep(Team.left); // start with the prep timer running
      expect(prepTimeMixin.isAnyPrepRunning, isTrue);
    });
    test('isOtherRunning returns the run status of the other timer', () {
      expect(prepTimeMixin.isAnyPrepRunning, isFalse);
      prepTimeMixin.startPrep(Team.left);
      expect(prepTimeMixin.isOtherPrepRunning(Team.right), isTrue);
      expect(prepTimeMixin.isOtherPrepRunning(Team.left), isFalse);
    });
    test('isRunning returns the run state of the given timer', () {
      expect(prepTimeMixin.isPrepRunning(Team.left), isFalse);
      expect(prepTimeMixin.isPrepRunning(Team.right), isFalse);
      prepTimeMixin.startPrep(Team.left); // only turn on one timer and check
      expect(prepTimeMixin.isPrepRunning(Team.left), isTrue);
      expect(prepTimeMixin.isPrepRunning(Team.right), isFalse);
    });
    test('isNotRunning returns the negated run state of the given timer', () {
      expect(prepTimeMixin.isPrepNotRunning(Team.left), isTrue);
      expect(prepTimeMixin.isPrepNotRunning(Team.right), isTrue);
      prepTimeMixin.startPrep(Team.left); // only turn on one timer and check
      expect(prepTimeMixin.isPrepNotRunning(Team.left), isFalse);
      expect(prepTimeMixin.isPrepNotRunning(Team.right), isTrue);
    });
    test('isAnyRunning returns true if the prep for any team is running', () {
      expect(prepTimeMixin.isAnyPrepRunning, isFalse);
      prepTimeMixin.startPrep(Team.left); // only turn on one timer and check
      expect(prepTimeMixin.isAnyPrepRunning, isTrue);
    });
    test('prepName returns PRO/CON (useAffNeg = false)', () {
      expect(prepTimeMixin.prepName(Team.left), equals('PRO'));
      expect(prepTimeMixin.prepName(Team.right), equals('CON'));
    });
    tearDown(() {
      prepTimeMixin.disposePrepTimers();
    });
  });
}
