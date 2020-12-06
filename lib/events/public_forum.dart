import 'package:preptime/provider/models/debate_event.dart';

/// Defines two pre-assembled Public Forum format debate events.
abstract class PublicForum {
  /// General rules for all forms of public forum debate.
  static const bool _useJudgeAssisitant = false;
  static const bool _shouldCountUp = false;

  /// Rules for Public Forum Debate.
  static const int _hsConstructive = 4;
  static const int _hsRebuttal = 2;
  static const int _hsSummary = 3;
  static const int _hsFinalFocus = 2;
  static const int _hsPrepTime = 2;
  static const int _hsCrossX = 3;

  DebateEvent get hsPublicForum => DebateEvent(
    name: 'HS Public Forum',
    description: '',
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
