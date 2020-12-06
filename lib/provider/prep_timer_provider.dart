import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:preptime/provider/models/speech.dart';
import 'package:preptime/provider/models/speech_event.dart';
import 'package:preptime/provider/models/event_controller.dart';

/// Manages the providers used in PrepTime.
class PrepTimeProvider extends StatelessWidget {
  /// The child of the Provider.
  final Widget child;

  /// The eventManager to track.
  final EventController eventManager = EventController();

  /// Provides access to models throughout the widget tree.
  PrepTimeProvider({this.child}) {
    eventManager.events.add(
      SpeechEvent(
        name: 'Event Name',
        description: 'This is a speech event.',
        speech: Speech(
          name: 'Speech',
          length: Duration(seconds: 10),
          shouldCountUp: false,
          useJudgeAssistant: false,
        ),
      ),
    );
    eventManager.setEvent(eventManager.events.first);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: child,
      providers: [
        ChangeNotifierProvider<Speech>(
          create: (_) => eventManager.event.speech,
        ),
        ChangeNotifierProvider<EventController>.value(
          value: eventManager,
        ),
      ],
    );
  }
}
