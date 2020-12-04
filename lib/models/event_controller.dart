import 'package:flutter/material.dart';
import 'package:preptime/models/event.dart';

/// Controlls a list of events.
///
/// The [EventController] keeps track of a collection of [Event]s that the user
/// has created timers for, as well as a singular [Event] that is assigned when
/// the user selects an event from the list.
class EventController extends ChangeNotifier {
  /// The selected [Event].
  Event event;

  /// A set of [Event]s that the user has timers for.
  final Set<Event> events = Set();

  /// Adds the event to the list.
  void add(Event event) {
    events.add(event);
    notifyListeners();
  }

  /// Removes the event to the list.
  void remove(Event e) {
    events.remove(e);
    notifyListeners();
  }

  /// Selects the given event.
  ///
  /// The given event must be in the set of [events].
  void setEvent(Event e) {
    if (events.contains(e)) {
      event = e;
      notifyListeners();
    }
  }

  /// Removes the selected event.
  void clearEvent() {
    event = null;
    notifyListeners();
  }

  @override
  void dispose() {
    event = null;
    for (Event eachEvent in events) {
      eachEvent.dispose();
    }
    super.dispose();
  }
}
