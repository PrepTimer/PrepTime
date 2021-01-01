// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

import 'package:flutter/widgets.dart';
import 'package:preptime/models/event.dart';
import 'package:preptime/models/speech.dart';

/// A SpeechEvent is an Event in which a single speech is given.
///
/// The timer in a speech event counts up, whereas the timer in a [DebateEvent]
/// will count down.
class SpeechEvent extends Event {
  /// Constructs a new speech event with the given speech object.
  ///
  /// The [name], [description], and [speech] parameters are all required.
  SpeechEvent({
    String name,
    String description,
    Speech speech,
  })  : assert(name != null),
        assert(description != null),
        assert(speech != null),
        super(name: name, description: description, speech: speech);

  /// Initializes the controller.
  ///
  /// Binds the TickerProvider to the AnimationController and if the speech
  /// uses JudgeAssistant, the controller will also add the onStatusChange
  /// callback to the controller.
  ///
  /// The [context] and [ticker] parameters are required, but the [onSpeechEnd]
  /// parameter is optonal.
  @override
  void initSpeechController(
    TickerProvider ticker, {
    BuildContext context,
    void Function(BuildContext) onSpeechEnd,
  }) {
    assert(ticker != null);
    assert(context != null);
    speech.initController(
      ticker,
      context,
      onSpeechEnd: () => onSpeechEnd?.call(context),
    );
  }

  @override
  void dispose() {
    speech?.dispose();
    speech = null;
    super.dispose();
  }
}
