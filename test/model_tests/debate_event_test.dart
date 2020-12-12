import 'package:preptime/debate_events/debate_events.dart';
import 'package:preptime/provider/models/debate_event.dart';
import 'package:preptime/provider/models/speech.dart';
import 'package:test/test.dart';

void main() {
  group('DebateEvent', () {
    DebateEvent debateEvent;
    setUp(() {
      debateEvent = Policy.highSchool();
    });
    test('The speeches getter returns a non-null list of speeches.', () {
      expect(debateEvent.speeches, isNotNull);
      expect(debateEvent.speeches is List<Speech>, isTrue);
    });
    test('Calling nextSpeech() increments the speech index.', () {});
    test('Calling nextSpeech() on last index throws IndexError.', () {});
    test('Calling prevSpeech() decrements the speech index.', () {});
    test('Calling prevSpeech() on first index throws IndexError.', () {});
    test('dispose() clears the list of speeches.', () {
      debateEvent.dispose();
      expect(debateEvent.speeches, isEmpty);
    });
    tearDown(() {
      debateEvent.dispose();
    });
  });
}
