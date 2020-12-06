library debate_events;

import 'package:preptime/provider/models/debate_event.dart';
import 'package:preptime/provider/models/speech.dart';

part 'src/lincoln_douglas.dart';
part 'src/public_forum.dart';
part 'src/policy.dart';

/// General rules for lincoln-douglas debate.
const bool _useJudgeAssisitant = false;
const bool _shouldCountUp = false;

/// Creates a new speech with the given parameters.
Speech _createSpeech(String name, int minutes) {
  return Speech(
    name: name,
    shouldCountUp: _shouldCountUp,
    useJudgeAssistant: _useJudgeAssisitant,
    length: Duration(minutes: minutes),
  );
}
