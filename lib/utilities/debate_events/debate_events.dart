// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

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
