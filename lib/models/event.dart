import 'package:flutter/widgets.dart';
import 'package:preptime/models/speech.dart';
import 'package:preptime/models/speech_status.dart';

/// An academic forensics event.
///
/// There are two types of forensics events, [DebateEvent] and [SpeechEvent].
/// They both share this interface, which includes the [name] of the event, the
/// [description] of the event, and the current [speech] being given. Only the
/// debate events can change the speech that is given, but both implement the
/// [nextSpeech] and [prevSpeech] methods.
abstract class Event extends ChangeNotifier {
  /// The name of the event.
  final String name;

  /// A short description of the event.
  final String description;

  /// The current speech being given.
  Speech speech;

  /// The number of speeches in this event.
  int get numSpeeches => 1;

  /// Tracks the current speech index.
  int get currentSpeechIndex => 1;

  /// Constructs a new Event with the given name and description.
  Event({this.name, this.description, this.speech})
      : assert(name != null),
        assert(description != null),
        assert(speech != null);

  /// Selects and returns the next speech.
  void nextSpeech() => throw UnimplementedError();

  /// Selects and returns the previous speech.
  void prevSpeech() => throw UnimplementedError();

  void start() {
    speech.start();
    notifyListeners();
  }

  void stop() {
    speech.stop();
    notifyListeners();
  }

  void resume() {
    speech.resume();
    notifyListeners();
  }

  void reset() {
    speech.reset();
    notifyListeners();
  }

  /// Initializes the controller.
  ///
  /// Binds the TickerProvider to the AnimationController and if the speech
  /// uses JudgeAssistant, the controller will also add the onStatusChange
  /// callback to the controller.
  void initSpeechController(
    TickerProvider ticker, {
    void Function() onSpeechEnd,
  }) {
    speech.initController(ticker, onStatusChanged: (AnimationStatus status) {
      if (_isSpeechAnimationCompleted(status)) {
        onSpeechEnd();
        speech.status = SpeechStatus.completed;
        notifyListeners();
        if (speech.useJudgeAssistant) {
          Speech.scrollToNextPageWithinBounds(numSpeeches);
        }
      }
    });
  }

  @override
  void dispose() {
    speech?.dispose();
    speech = null;
    super.dispose();
  }

  bool _isSpeechAnimationCompleted(AnimationStatus status) {
    bool shouldCountUp = speech.shouldCountUp;
    return (shouldCountUp && status == AnimationStatus.completed) ||
        (!shouldCountUp && status == AnimationStatus.dismissed);
  }
}
