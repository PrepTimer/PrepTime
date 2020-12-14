import 'package:preptime/models/event.dart';
import 'package:preptime/models/speech.dart';
import 'package:test/test.dart';

class MockEvent extends Event {
  MockEvent()
      : super(name: 'name', description: 'description', speech: Speech());
}

void main() {
  group('Event', () {
    Event event;
    setUp(() {
      event = MockEvent();
    });
    test('name field equals the value given in the constructor', () {
      expect(event.name, equals('name'));
    });
    test('description field equals the value given in the constructor', () {
      expect(event.description, equals('description'));
    });
    test('speech field equals the value given in the constructor', () {
      expect(event.speech, isA<Speech>());
    });
    test('nextSpeech throws UnimplementedError', () {
      expect(() => event.nextSpeech(), throwsUnimplementedError);
    });
    test('prevSpeech throws UnimplementedError', () {
      expect(() => event.prevSpeech(), throwsUnimplementedError);
    });
    test('dispose() makes the speech null', () {
      expect(event.speech, isNotNull);
      event.dispose();
      expect(event.speech, isNull);
      event = MockEvent();
    });
    tearDown(() {
      event.dispose();
    });
  });
}
