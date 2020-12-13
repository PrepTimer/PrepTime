import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:preptime/models/event.dart';

/// Controlls a list of events.
///
/// The [EventController] keeps track of a collection of [Event]s that the user
/// has created timers for, as well as a singular [Event] that is assigned when
/// the user selects an event from the list.
class EventController extends ChangeNotifier {
  /// A set of [Event]s that the user has timers for.
  final Set<Event> events = LinkedHashSet();

  Event _event;

  /// The selected [Event].
  Event get event => _event;

  /// Selects the given event.
  ///
  /// The given event must be in the set of [events].
  set event(Event e) {
    if (events.contains(e)) {
      _event = e;
      notifyListeners();
    }
  }

  /// Adds the event to the list.
  ///
  /// If the event (or an equal event) was already in the list, nothing happens.
  void add(Event event) {
    if (events.add(event)) notifyListeners();
  }

  /// Removes the event to the list.
  ///
  /// If the event is not in the list, nothing happens.
  void remove(Event e) {
    if (events.remove(e)) notifyListeners();
  }

  /// Removes the selected event.
  void clearEvent() {
    _event = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _event = null;
    for (Event eachEvent in events) {
      eachEvent.dispose();
    }
    events.clear();
    super.dispose();
  }
}
