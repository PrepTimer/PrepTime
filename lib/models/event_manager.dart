import 'package:flutter/material.dart';
import 'package:preptime/models/event.dart';

/// Manages a list of events.
///
/// The [EventManager] keeps track of a collection of [Event]s that the user has
/// created timers for, as well as a singular [Event] that is assigned when the
/// user selects an event from the list.
class EventManager extends ChangeNotifier {
  /// The selected [Event].
  Event event;

  /// A set of [Event]s that the user has timers for.
  Set<Event> events;

  /// Adds the event to the list.
  void add(Event event) {
    events.add(event);
  }

  /// Removes the event to the list.
  void remove(Event e) {
    events.remove(e);
  }

  /// Selects the given event.
  /// 
  /// The given event must be in the set of [events].
  void setEvent(Event e) {
    if (events.contains(e)) {
      event = e;
    }
  }

  /// Removes the selected event.
  void clearEvent() {
    event = null;
  }
}
