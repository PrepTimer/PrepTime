import 'package:flutter/widgets.dart';
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

  /// Initializes the controller.
  ///
  /// Binds the TickerProvider to the AnimationController and if the speech
  /// uses JudgeAssistant, the controller will also add the onStatusChange
  /// callback to the controller.
  void initSpeechController(
    TickerProvider ticker, {
    BuildContext context,
    void Function() onSpeechEnd,
  }) {
    speech.initController(ticker, context, onStatusChanged: (
      AnimationStatus status,
    ) {
      if (_isSpeechAnimationCompleted(status)) {
        onSpeechEnd();
        _autoScroll(speech);
      }
    });
  }

  bool _isSpeechAnimationCompleted(AnimationStatus status) {
    bool shouldCountUp = speech.shouldCountUp;
    return (shouldCountUp && status == AnimationStatus.completed) ||
        (!shouldCountUp && status == AnimationStatus.dismissed);
  }

  void _autoScroll(Speech speech) {
    if (speech.useJudgeAssistant) {
      scrollToNextPageIfSafe();
    }
  }
}
