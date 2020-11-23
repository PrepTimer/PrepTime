import 'package:flutter/material.dart';
import 'package:preptime/models/speech.dart';

/// Define the two main skill levels to use (either a novice or expert).
enum SkillLevel { novice, expert }

/// Defines the two teams as the left team and the right team.
enum Team { left, right }

/// Defines the state and behavior of a speech or debate event.
class Event extends ChangeNotifier {
  final Duration leftTeamPrepTime, rightTeamPrepTime;
  final String name, leftTeamName, rightTeamName;
  final List<Speech> speeches;
  final SkillLevel skill;

  int _currentSpeechIndex = -1;

  /// Constructs a new debate event object.
  ///
  /// - `name` - the name of the event.
  /// - `leftTeamName` - the name of the left team on the screen (ie. 'AFF').
  /// - `rightTeamName` - the name of the right team on the screen (ie. 'NEG').
  /// - `speeches` - an ordered list of speech objects.
  /// - `skill` - whether to use judge assistant mode or not.
  /// - `prepTime` - the amount of prep time each team gets in this debate.
  Event.createDebateEvent({
    @required this.name,
    @required this.leftTeamName,
    @required this.rightTeamName,
    @required this.speeches,
    @required this.skill,
    @required prepTime,
  })  : leftTeamPrepTime = prepTime,
        rightTeamPrepTime = prepTime;

  /// Constructs a new speech event object.
  ///
  /// - `speech` - a speech object representing the speech event's main gig.
  /// - `skill` - whether to use judge assistant mode or not.
  Event.createSpeechEvent({Speech speech, this.skill})
      : name = speech.name,
        leftTeamName = null,
        rightTeamName = null,
        speeches = [speech],
        leftTeamPrepTime = null,
        rightTeamPrepTime = null;

  Speech nextSpeech() {
    return null;
  }

  Speech prevSpeech() {
    return null;
  }

  void startSpeech() {}
  void pauseSpeech() {}
  void resumeSpeech() {}
  void cancelSpeech() {}

  void startPrep(Team team) {}
  void pausePrep(Team team) {}
  void resetPrep(Team team) {}
}