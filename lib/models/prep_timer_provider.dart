import 'package:flutter/material.dart';
import 'package:preptime/models/event.dart';
import 'package:preptime/models/event_manager.dart';
import 'package:preptime/models/speech.dart';
import 'package:preptime/models/speech_event.dart';
import 'package:provider/provider.dart';

/// Manages the providers used in PrepTime.
class PrepTimeProvider extends StatelessWidget {
  /// The child of the Provider.
  final Widget child;

  /// The eventManager to track.
  final EventManager eventManager = EventManager();

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
        ChangeNotifierProvider<EventManager>.value(
          value: eventManager,
        ),
        ProxyProvider<EventManager, Event>(
          create: (_) => eventManager.event,
          update: (_, newEventManager, __) => newEventManager.event,
          updateShouldNotify: (previous, current) => previous != current,
        ),
        ProxyProvider<Event, Speech>(
          create: (_) => eventManager.event?.speech,
          update: (_, newEvent, __) => newEvent.speech,
          updateShouldNotify: (previous, current) => previous != current,
          dispose: (_, __) => eventManager.dispose(),
        ),
      ],
    );
  }
}
