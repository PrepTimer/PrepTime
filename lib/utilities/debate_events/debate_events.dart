library debate_events;

import 'package:preptime/models/debate_event.dart';
import 'package:preptime/models/speech.dart';

part 'src/lincoln_douglas.dart';
part 'src/public_forum.dart';
part 'src/policy.dart';

/// Creates a new speech with the given parameters.
Speech _createSpeech(String name, int minutes) {
  return Speech(
    name: name,
    shouldCountUp: false,
    useJudgeAssistant: true,
    length: Duration(minutes: minutes),
  );
}
