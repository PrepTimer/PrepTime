import 'package:flutter/material.dart';
import 'package:preptime/models/event.dart';
import 'package:preptime/utilities/debate_events/debate_events.dart';
import 'package:provider/provider.dart';
import 'package:preptime/models/speech.dart';
import 'package:preptime/models/event_controller.dart';

/// Manages the providers used in PrepTime.
class PrepTimeProvider extends StatelessWidget {
  /// The child of the Provider.
  final Widget child;

  /// The eventManager to track.
  final EventController eventController = EventController();

  /// Provides access to models throughout the widget tree.
  PrepTimeProvider({this.child}) {
    eventController.events.add(Policy.highSchool());
    eventController.events.add(LincolnDouglas.highSchool());
    eventController.events.add(PublicForum.highSchool());
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: child,
      providers: [
        ChangeNotifierProvider<Speech>.value(
          value: eventController.event.speech,
        ),
        ChangeNotifierProvider<Event>.value(
          value: eventController.event,
        ),
        ChangeNotifierProvider<EventController>.value(
          value: eventController,
        ),
      ],
    );
  }
}
