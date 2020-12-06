import 'package:preptime/provider/models/debate_event.dart';
import 'package:preptime/provider/models/speech.dart';

abstract class LincolnDouglasDebate {
  /// General rules for all forms of policy debate.
  static const bool _useJudgeAssisitant = false;
  static const bool _shouldCountUp = false;

  DebateEvent get _hsLincolnDouglasDebate =>
      DebateEvent(); // TODO: Fill this in!!!!!

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
