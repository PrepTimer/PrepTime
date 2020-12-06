part of 'debate_events.dart';

abstract class LincolnDouglasDebate {
  /// General rules for lincoln-douglas debate.
  static const bool _useJudgeAssisitant = false;
  static const bool _shouldCountUp = false;
  static const int _prepTime = 4;
  static const int _crossX = 4;

  DebateEvent get hsLincolnDouglasDebate => DebateEvent(
        name: 'HS Lincoln-Douglas',
        description: '$_prepTime\' Prep',
        speeches: [
          _createSpeech('AC', 4),
          _createSpeech('CX', _crossX),
          _createSpeech('NC', 8),
          _createSpeech('CX', _crossX),
          _createSpeech('1AR', 4),
          _createSpeech('NR', 5),
          _createSpeech('2AR', 4),
        ],
      );

  /// Creates a new speech with the given parameters.
  Speech _createSpeech(String name, int minutes) {
    return Speech(
      name: name,
      shouldCountUp: _shouldCountUp,
      useJudgeAssistant: _useJudgeAssisitant,
      length: Duration(minutes: minutes),
    );
  }
}
