import 'package:preptime/provider/models/prep_time_mixin.dart';
import 'package:preptime/provider/models/speech_event.dart';
import 'package:preptime/provider/models/team.dart';
import 'package:test/test.dart';

/// This is probably an anti-pattern.
///
/// The [PrepTimeMixin] should really only be defined for [DebateEvents], but
/// technically it can be mixed in on any [Event]. Therefore, to prevent
/// isolate the [PrepTimeMixin] for testing, we will create this
/// [TestPrepTimeMixin] class and then go ahead and not use any of the
/// [SpeechEvent] parts of the parent.
class TestPrepTimeMixin extends SpeechEvent with PrepTimeMixin {}

void main() {
  group('PrepTimeMixin', () {
    TestPrepTimeMixin prepTimeMixin;
    setUp(() {
      prepTimeMixin = TestPrepTimeMixin();
    });
    test('initialPrep is initially null', () {
      expect(prepTimeMixin.initialPrep, isNull);
    });
    test('initialPrep equals duration after initPrepTimers is called', () {
      Duration _duration = const Duration(minutes: 3);
      expect(prepTimeMixin.initialPrep, isNull);
      prepTimeMixin.initPrepTimers(duration: _duration);
      expect(prepTimeMixin.initialPrep, equals(_duration));
    });
    test('initTimers constructs timers for each team', () {
      expect(prepTimeMixin.remainingPrep(Team.left), isNull);
      expect(prepTimeMixin.remainingPrep(Team.right), isNull);
      prepTimeMixin.initPrepTimers(duration: const Duration(minutes: 3));
      expect(prepTimeMixin.remainingPrep(Team.left), isNotNull);
      expect(prepTimeMixin.remainingPrep(Team.right), isNotNull);
    });
    test('disposePrepTimers', () {});
    test('isRunning', () {});
    test('isNotRunning', () {});
    test('isOtherRunning', () {});
    test('startPrep', () {});
    test('stopPrep', () {});
    test('togglePrep', () {});
    test('resetPrep', () {});
    test('remainingPrep', () {});
    test('prepName', () {});
    tearDown(() {});
  });
}
