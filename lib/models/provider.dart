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
    eventController.add(Policy.highSchool());
    eventController.add(LincolnDouglas.highSchool());
    eventController.add(PublicForum.highSchool());
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: child,
      providers: [
        ChangeNotifierProvider<EventController>.value(
          value: eventController,
        ),
        ChangeNotifierProxyProvider<EventController, Event>(
          create: (_) => eventController.event,
          update: (_, controller, __) {
            print('updating Event');
            return controller.event;
          },
        ),
      ],
    );
  }
}
