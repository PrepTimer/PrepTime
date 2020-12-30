// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:preptime/models/event.dart';
import 'package:preptime/models/event_controller.dart';
import 'package:preptime/models/platform_info.dart';
import 'package:preptime/models/provider.dart';

class MockProvider extends PrepTimeProvider {
  /// Constructs a new mock provider.
  ///
  /// The [child] parameter is required and is build as the child of this
  /// provider. The platform info defaults to isIOS, and the events defaults
  /// to a set of three high-school level debate events: Policy, LincolnDouglas,
  /// and PublicForum.
  MockProvider({
    @required Widget child,
    PlatformInfo platform = const PlatformInfo.iOS(),
    List<Event> events,
  }) : super(child: child, platformInfo: platform);

  /// Returns the event from the given event controller.
  ///
  /// For testing, this method calls initController on the event before
  /// returning it using the given buildContext.
  @override
  Event getEventFromController(
    EventController controller,
    BuildContext context,
  ) {
    Event event = controller.event;
    event.initSpeechController(TestVSync(), context: context);
    return event;
  }
}
