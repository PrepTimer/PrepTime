// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

import 'package:preptime/models/event_controller.dart';
import 'package:preptime/utilities/debate_events/debate_events.dart';
import 'package:test/test.dart';

void main() {
  group('EventController', () {
    EventController eventController;
    setUp(() {
      eventController = EventController();
    });
    test('event getter returns the set event', () {
      eventController.add(Policy.highSchool());
      expect(eventController.event, isA<Policy>());
    });
    test('event setter sets if event is contained in events', () {
      eventController.add(Policy.middleSchool());
      eventController.add(LincolnDouglas.highSchool());
      eventController.event = eventController.events.last; // set event to LD
      expect(eventController.event, isA<LincolnDouglas>());
    });
    test('event setter throws ArgumentError if event is not in events', () {
      eventController.add(Policy.middleSchool());
      expect(
        () => eventController.event = PublicForum.highSchool(), // not in events
        throwsArgumentError,
      );
    });
    test('adding a unique event makes the set longer', () {
      expect(eventController.events.length, equals(0));
      eventController.add(Policy.college());
      expect(eventController.events.length, equals(1));
    });
    test('adding a duplicate event does nothing', () {
      expect(eventController.events.length, equals(0));
      eventController.add(PublicForum.highSchool());
      expect(eventController.events.length, equals(1)); // adds a new event
      eventController.add(PublicForum.highSchool());
      expect(eventController.events.length, equals(1)); // drops duplicate event
    });
    test('removing an existing event makes the set shorter', () {
      eventController.add(LincolnDouglas.highSchool());
      expect(eventController.events.length, equals(1));
      eventController.remove(LincolnDouglas.highSchool());
      expect(eventController.events.length, equals(0));
    });
    test('removing an event that was not in the set does nothing', () {
      eventController.add(Policy.highSchool());
      expect(eventController.events.length, equals(1));
      eventController.remove(PublicForum.highSchool());
      expect(eventController.events.length, equals(1));
    });
    test('clearEvent makes event null', () {
      eventController.add(Policy.highSchool());
      expect(eventController.event, isNotNull);
      eventController.clearEvent();
      expect(eventController.event, isNull);
    });
    test('dispose makes event null', () {
      eventController.add(Policy.highSchool());
      expect(eventController.event, isNotNull);
      eventController.dispose();
      expect(eventController.event, isNull);
    });
    test('dispose makes events empty', () {
      eventController.add(Policy.highSchool());
      expect(eventController.events, isNotEmpty);
      eventController.dispose();
      expect(eventController.events, isEmpty);
    });
  });
}
