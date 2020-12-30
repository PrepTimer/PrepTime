// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:preptime/models/event.dart';
import 'package:preptime/models/platform_info.dart';
import 'package:preptime/utilities/debate_events/debate_events.dart';
import 'package:provider/provider.dart';
import 'package:preptime/models/event_controller.dart';

/// Manages the providers used in PrepTime.
class PrepTimeProvider extends StatelessWidget {
  /// The child of the Provider.
  final Widget child;

  /// The eventManager to track.
  final EventController eventController = EventController();

  /// The current platform.
  final PlatformInfo platformInfo;

  /// Provides access to models throughout the widget tree.
  PrepTimeProvider({
    @required this.child,
    List<Event> events,
    PlatformInfo platformInfo,
  }) : this.platformInfo = platformInfo ??
            PlatformInfo(
              isAndroid: Platform.isAndroid,
              isIOS: Platform.isIOS,
            ) {
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
          create: (_) => getEventFromController(eventController, context),
          update: (_, controller, __) => getEventFromController(
            controller,
            context,
          ),
        ),
      ],
    );
  }

  /// Returns the event from the given event controller.
  ///
  /// The [context] parameter is for testing purposes, see [mock_provider].
  Event getEventFromController(
    EventController controller,
    BuildContext context,
  ) {
    return controller.event;
  }
}
