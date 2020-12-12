import 'package:preptime/provider/models/speech.dart';
import 'package:preptime/provider/models/speech_event.dart';
import 'package:test/test.dart';

void main() {
  group('SpeechEvent', () {
    SpeechEvent speechEvent;
    String _name = 'nameOfSpeechEvent';
    String _description = 'descriptionOfSpeechEvent';
    setUp(() {
      speechEvent = SpeechEvent(
        name: _name,
        description: _description,
        speech: Speech(),
      );
    });
    test('name field equals the value given in the constructor', () {
      expect(speechEvent.name, equals(_name));
    });
    test('description field equals the value given in the constructor', () {
      expect(speechEvent.description, equals(_description));
    });
    test('speech field equals the value given in the constructor', () {
      expect(speechEvent.speech, isA<Speech>());
    });
    test('nextSpeech throws UnimplementedError', () {
      expect(() => speechEvent.nextSpeech(), throwsUnimplementedError);
    });
    test('prevSpeech throws UnimplementedError', () {
      expect(() => speechEvent.prevSpeech(), throwsUnimplementedError);
    });
    test('dispose() makes the speech null', () {
      expect(speechEvent.speech, isNotNull);
      speechEvent.dispose();
      expect(speechEvent.speech, isNull);
      speechEvent = SpeechEvent();
    });
    tearDown(() {
      speechEvent.dispose();
    });
  });
}
