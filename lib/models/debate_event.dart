import 'package:preptime/models/event.dart';
import 'package:preptime/models/prep_time_mixin.dart';
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

  /// The number of speeches in this event.
  @override
  int get numSpeeches => this.speeches.length;

  /// Sets the current speech to be the next speech.
  ///
  /// Throws RangeError if the current speech is the last speech.
  @override
  void nextSpeech() {
    int currentIndex = speeches.indexOf(super.speech);
    if (currentIndex >= 0 && currentIndex < speeches.length - 1) {
      super.speech = speeches[currentIndex + 1];
      notifyListeners();
    } else {
      throw RangeError('NextSpeech: Index out of range.');
    }
  }

  /// Sets the current speech to be the previous speech.
  ///
  /// Throws RangeError if the current speech is the first speech.
  @override
  void prevSpeech() {
    int currentIndex = speeches.indexOf(super.speech);
    if (currentIndex == 0) {
      throw RangeError('PrevSpeech: Index out of range.');
    } else {
      super.speech = speeches[currentIndex - 1];
      notifyListeners();
    }
  }

  @override
  void dispose() {
    for (Speech speech in speeches) {
      speech.dispose();
    }
    speeches.clear();
    super.speech = null;
    disposePrepTimers();
    super.dispose();
  }
}
