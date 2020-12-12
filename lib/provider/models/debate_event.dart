import 'package:preptime/provider/models/event.dart';
import 'package:preptime/provider/models/prep_time_mixin.dart';
import 'package:preptime/provider/models/speech.dart';

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
  /// Throws IndexError if the current speech is the last speech.
  @override
  void nextSpeech() {
    int currentIndex = speeches.indexOf(super.speech);
    if (currentIndex == speeches.length - 1) {
      throw IndexError(currentIndex, speeches);
    } else {
      super.speech = speeches[currentIndex++];
      notifyListeners();
    }
  }

  /// Sets the current speech to be the previous speech.
  ///
  /// Throws IndexError if the current speech is the first speech.
  @override
  void prevSpeech() {
    int currentIndex = speeches.indexOf(super.speech);
    if (currentIndex == 0) {
      throw IndexError(currentIndex, speeches);
    } else {
      super.speech = speeches[currentIndex--];
      notifyListeners();
    }
  }

  @override
  void dispose() {
    for (Speech s in speeches) {
      s.dispose();
    }
    speeches.clear();
    disposePrepTimers();
    super.dispose();
  }
}
