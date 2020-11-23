import 'package:flutter/widgets.dart';
import 'package:preptime/models/event.dart';
import 'package:preptime/models/speech.dart';

class EventManager extends ChangeNotifier {
  final List<Event> events = [];
  int _currentEvent = -1;

  EventManager() {
    // TODO: Initialize the event manager to be empty.
    Event event = Event.createDebateEvent(
      name: 'HS Policy Debate',
      leftTeamName: 'AFF',
      rightTeamName: 'NEG',
      speeches: [
        Speech(
          name: '1AC',
          length: Duration(minutes: 8),
          direction: TimerDirection.countDown,
          onEnd: null,
        )
      ],
      skill: SkillLevel.expert,
      prepTime: Duration(minutes: 8),
    );
    addEvent(event);
    _currentEvent = 0;
  }

  /// Adds the given event to the list of events.
  void addEvent(Event event) {
    events.add(event);
  }

  /// Removes the event at the given index from the list of events.
  void removeEvent(int index) {
    events.removeAt(index);
  }

  /// Returns the current event object.
  ///
  /// Throws ArgumentError if something goes wrong.
  Event getEvent() {
    try {
      return events[_currentEvent];
    } catch (_) {
      throw ArgumentError('Invalid event name.');
    }
  }

  /// Returns the current speech object.
  ///
  /// Throws ArgumentError if something goes wrong.
  Speech getSpeech() {
    try {
      return getEvent().getSpeech();
    } on IndexError {
      throw IndexError(_currentEvent, events);
    } catch (e) {
      print('Shit hit the fan. Not sure what happened: $e');
      rethrow;
    }
  }
}
