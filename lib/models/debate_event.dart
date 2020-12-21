import 'package:flutter/widgets.dart';
import 'package:preptime/models/event.dart';
import 'package:preptime/models/prep_time_mixin.dart';
import 'package:preptime/models/speech.dart';
import 'package:preptime/models/speech_status.dart';

/// A [DebateEvent] is an [Event] in which multiple speechs are given.
///
/// The timer in a debate event counts down, whereas the timer in a
/// [SpeechEvent] will count up. For a [DebateEvent], the [nextSpeech] and
/// [prevSpeech] methods will change the value of the speech field and trigger
/// updates in the UI.
class DebateEvent extends Event with PrepTimeMixin {
  final List<Speech> speeches;

  DebateEvent({
    String name,
    String description,
    this.speeches,
  })  : assert(name != null),
        assert(description != null),
        assert(speeches.isNotEmpty),
        super(name: name, description: description, speech: speeches.first);

  @override
  int get numSpeeches => this.speeches.length;

  @override
  int get currentSpeechIndex => speeches.indexOf(super.speech);

  /// Sets the current speech to be the next speech.
  ///
  /// Throws RangeError if the current speech is the last speech.
  @override
  void nextSpeech() {
    if (currentSpeechIndex >= 0 && currentSpeechIndex < speeches.length - 1) {
      super.speech = speeches[currentSpeechIndex + 1];
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
    if (currentSpeechIndex == 0) {
      throw RangeError('PrevSpeech: Index out of range.');
    } else {
      super.speech = speeches[currentSpeechIndex - 1];
      notifyListeners();
    }
  }

  /// Initializes the controller.
  ///
  /// Binds the TickerProvider to the AnimationController and if the speech
  /// uses JudgeAssistant, the controller will also add the onStatusChange
  /// callback to the controller.
  @override
  void initSpeechController(
    TickerProvider ticker, {
    void Function() onSpeechEnd,
  }) {
    for (Speech speech in speeches) {
      _initSpeechControllerWithTickerAndCallback(speech, ticker, onSpeechEnd);
    }
  }

  @override
  void dispose() {
    for (Speech speech in speeches) {
      speech.dispose();
    }
    speeches.clear();
    disposePrepTimers();
    super.dispose();
  }

  void _initSpeechControllerWithTickerAndCallback(
    Speech speech,
    TickerProvider ticker,
    void Function() onSpeechEnd,
  ) {
    speech.initController(ticker, onStatusChanged: (AnimationStatus status) {
      if (_isSpeechAnimationCompleted(status)) {
        onSpeechEnd();
        speech.status = SpeechStatus.completed;
        notifyListeners();
      }
      _autoScrollIfUsingJudgeAssistant(speech.useJudgeAssistant);
    });
  }

  bool _isSpeechAnimationCompleted(AnimationStatus status) {
    bool shouldCountUp = speech.shouldCountUp;
    return (shouldCountUp && status == AnimationStatus.completed) ||
        (!shouldCountUp && status == AnimationStatus.dismissed);
  }

  void _autoScrollIfUsingJudgeAssistant(bool useJudgeAssistant) {
    if (useJudgeAssistant) {
      Speech.scrollToNextPageWithinBounds(numSpeeches);
    }
  }
}
