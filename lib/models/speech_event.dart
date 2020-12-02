import 'package:preptime/models/event.dart';
import 'package:preptime/models/speech.dart';

/// A SpeechEvent is an Event in which a single speech is given.
/// 
/// The timer in a speech event counts up, whereas the timer in a [DebateEvent]
/// will count down. For a SpeechEvent, the [nextSpeech] and [prevSpeech]
/// methods will throw an UnimplementedError.
class SpeechEvent extends Event {
  /// Constructs a new speech event with the given speech object.
  SpeechEvent({
    String name,
    String description,
    Speech speech,
  }) : super(name: name, description: description, speech: speech);

  /// Throws unimplemented error.
  @override
  void nextSpeech() {
    throw UnimplementedError('Cannot call nextSpeech on SpeechEvent.');
  }

  /// Throws unimplemented error.
  @override
  void prevSpeech() {
    throw UnimplementedError('Cannot call prevSpeech on SpeechEvent.');
  }
}
