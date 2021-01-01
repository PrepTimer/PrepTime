// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

import 'package:flutter/widgets.dart';
import 'package:preptime/models/speech.dart';
import 'package:preptime/models/timeable.dart';

/// An academic forensics event.
///
/// There are two types of forensics events, [DebateEvent] and [SpeechEvent].
/// They both share this interface, which includes the [name] of the event, the
/// [description] of the event, and the current [speech] being given.
///
/// An event is also [Timeable], so you can call all the typical timer-like
/// methods such as [start], [stop], [resume], and [reset] in addition to both
/// [isRunning] and [isNotRunning].
abstract class Event extends ChangeNotifier implements Timeable {
  /// The name of the event.
  final String name;

  /// A short description of the event.
  final String description;

  /// The current speech being given.
  Speech speech;

  /// Constructs a new [Event] with the given name and description.
  ///
  /// The given [name], [description], and [speech] must not be null.
  Event({this.name, this.description, this.speech})
      : assert(name != null),
        assert(description != null),
        assert(speech != null);

  /// Whether the speech timer is running.
  bool get isRunning => speech.isRunning;

  /// Whether the speech timer is not running.
  bool get isNotRunning => speech.isNotRunning;

  /// Starts the speech timer.
  void start() {
    speech.start();
    notifyListeners();
  }

  /// Stops the speech timer.
  void stop() {
    speech.stop();
    notifyListeners();
  }

  /// Resumes the speech timer.
  void resume() {
    speech.resume();
    notifyListeners();
  }

  /// Resets the speech timer.
  void reset() {
    speech.reset();
    notifyListeners();
  }

  /// Initializes the speech controller.
  void initSpeechController(
    TickerProvider ticker, {
    BuildContext context,
    void Function(BuildContext) onSpeechEnd,
  });

  /// Disposes the resources used by this event.
  @override
  void dispose() {
    super.dispose();
  }
}
