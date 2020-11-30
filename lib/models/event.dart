import 'package:flutter/material.dart';
import 'package:preptime/models/speech.dart';

abstract class Event extends ChangeNotifier {
  /// A short description of the event.
  final String description;

  /// The name of the event.
  final String name;

  /// The current speech being given.
  Speech speech;

  /// Constructs a new Event with the given name and description.
  Event({this.name, this.description, this.speech});

  /// Selects and returns the next speech.
  void nextSpeech();

  /// Selects and returns the previous speech.
  void prevSpeech();
}
