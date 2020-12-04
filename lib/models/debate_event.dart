import 'package:preptime/models/event.dart';
import 'package:preptime/models/prep_time.dart';
import 'package:preptime/models/speech.dart';

/// A [DebateEvent] is an [Event] in which multiple speechs are given.
///
/// The timer in a debate event counts down, whereas the timer in a
/// [SpeechEvent] will count up. For a [DebateEvent], the [nextSpeech] and
/// [prevSpeech] methods will change the value of the speech field and trigger
/// updates in the UI.
class DebateEvent extends Event with PrepTimeMixin {
  /// A list of speeches that defines the structure of the event.
  final List<Speech> speeches;

  /// Constructs a new Debate event with the given list of speeches.
  DebateEvent({
    String name,
    String description,
    this.speeches,
  }) : super(name: name, description: description, speech: speeches.first);

  /// Sets the current speech to be the next speech.
  ///
  /// The current speech must not be the last speech.
  @override
  void nextSpeech() {
    if (super.speech != speeches.last) {
      int currentIndex = speeches.indexOf(super.speech);
      super.speech = speeches[currentIndex++];
      notifyListeners();
    }
  }

  /// Sets the current speech to be the previous speech.
  ///
  /// The current speech must not be the first speech.
  @override
  void prevSpeech() {
    if (super.speech != speeches.first) {
      int currentIndex = speeches.indexOf(super.speech);
      super.speech = speeches[currentIndex--];
      notifyListeners();
    }
  }

  @override
  void dispose() {
    for (Speech s in speeches) {
      s.dispose();
    }
    disposePrepTimers();
    super.dispose();
  }
}
