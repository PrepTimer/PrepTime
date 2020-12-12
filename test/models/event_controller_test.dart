import 'package:preptime/debate_events/debate_events.dart';
import 'package:preptime/provider/models/event_controller.dart';
import 'package:test/test.dart';

void main() {
  group('EventController', () {
    EventController eventController;
    setUp(() {
      eventController = EventController();
      eventController.events.add(Policy.highSchool());
      eventController.events.add(LincolnDouglas.highSchool());
      eventController.event = eventController.events.first;
    });
    test('event getter returns the set event', () {
      expect(eventController.event, isA<Policy>());
    });
    test('event setter sets if event is contained in events', () {
      eventController.event = eventController.events.last;
      expect(eventController.event, isA<LincolnDouglas>());
    });
    test('adding a unique event makes the set longer', () {
      expect(eventController.events.length, equals(2));
      eventController.events.add(PublicForum.highSchool());
      expect(eventController.events.length, equals(3));
    });
    test('adding a duplicate event does nothing', () {
      expect(eventController.events.length, equals(2));
      eventController.events.add(LincolnDouglas.highSchool());
      expect(eventController.events.length, equals(2));
    });
    test('removing an existing event makes the set shorter', () {
      expect(eventController.events.length, equals(2));
      eventController.remove(LincolnDouglas.highSchool());
      expect(eventController.events.length, equals(1));
    });
    test('removing an event that was not in the set does nothing', () {
      expect(eventController.events.length, equals(2));
      eventController.remove(PublicForum.highSchool());
      expect(eventController.events.length, equals(2));
    });
    test('clearEvent makes event null', () {
      expect(eventController.event, isNotNull);
      eventController.clearEvent();
      expect(eventController.event, isNull);
    });
    test('dispose makes event null', () {
      expect(eventController.event, isNotNull);
      eventController.dispose();
      expect(eventController.event, isNull);
    });
    test('dispose makes events empty', () {
      expect(eventController.events, isNotEmpty);
      eventController.dispose();
      expect(eventController.events, isEmpty);
    });
  });
}
