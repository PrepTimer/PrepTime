// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:preptime/models/event.dart';
import 'package:preptime/models/event_controller.dart';
import 'package:preptime/models/platform_info.dart';
import 'package:preptime/models/provider.dart';
import 'package:preptime/utilities/debate_events/debate_events.dart';
import 'package:provider/provider.dart';

class MockProvider extends PrepTimeProvider {
  /// The child of the Provider.
  final Widget child;

  /// The eventManager to track.
  final EventController eventController = EventController();

  /// The current platform.
  final PlatformInfo platformInfo;

  /// Constructs a new mock provider.
  ///
  /// The [child] parameter is required and is build as the child of this
  /// provider. The platform info defaults to isIOS, and the events defaults
  /// to a set of three high-school level debate events: Policy, LincolnDouglas,
  /// and PublicForum.
  MockProvider({
    @required this.child,
    this.platformInfo = const PlatformInfo.iOS(),
    List<Event> events,
  }) {
    if (events == null || events.isEmpty) {
      events = [
        Policy.highSchool(),
        LincolnDouglas.highSchool(),
        PublicForum.highSchool(),
      ];
    }
    for (Event event in events) {
      eventController.add(event);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: child,
      providers: [
        Provider<PlatformInfo>.value(
          value: platformInfo,
        ),
        ChangeNotifierProvider<EventController>.value(
          value: eventController,
        ),
        ChangeNotifierProxyProvider<EventController, Event>(
          create: (_) => _getFakeEventFromController(eventController, context),
          update: (_, controller, __) => _getFakeEventFromController(
            controller,
            context,
          ),
        ),
      ],
    );
  }

  /// Returns the event from the given event controller and calls initController
  /// on that event before returning it.
  Event _getFakeEventFromController(
    EventController controller,
    BuildContext context,
  ) {
    Event event = controller.event;
    event.initSpeechController(TestVSync(), context: context);
    return event;
  }
}
