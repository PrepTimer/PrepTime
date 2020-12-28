// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

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

  /// The selected [Event].
  Event get event => _event;
  Event _event;

  /// Selects the given event.
  ///
  /// Throws [ArgumentError] if the given event is not in the set of [events].
  set event(Event e) {
    if (events.contains(e)) {
      _event = e;
      notifyListeners();
    } else {
      throw ArgumentError();
    }
  }

  /// Adds the event to the list.
  ///
  /// If the event (or an equal event) was already in the list, nothing happens.
  /// If the new event is the only event in the eventController, the new event
  /// will automatically be set (in eventController.event).
  void add(Event event) {
    if (events.add(event)) {
      notifyListeners();
    }
    if (events.length == 1) {
      _event = event;
    }
  }

  /// Removes the event to the list.
  ///
  /// If the event is not in the list, nothing happens.
  void remove(Event e) {
    if (events.remove(e)) {
      notifyListeners();
    }
  }

  /// Removes the selected event.
  void clearEvent() {
    _event = null;
    notifyListeners();
  }

  /// Disposes the resources used by this EventController.
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
