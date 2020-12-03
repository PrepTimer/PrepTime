import 'package:flutter/material.dart';
import 'package:preptime/models/speech.dart';

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

  /// Constructs a new Event with the given name and description.
  Event({this.name, this.description, this.speech});

  /// Selects and returns the next speech.
  void nextSpeech();

  /// Selects and returns the previous speech.
  void prevSpeech();

  @override
  void dispose() {
    speech?.dispose();
    super.dispose();
  }
}
