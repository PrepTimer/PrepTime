// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:preptime/models/event.dart';
import 'package:preptime/models/platform_info.dart';
import 'package:preptime/models/provider.dart';
import 'package:preptime/utilities/debate_events/debate_events.dart';
import 'package:test/test.dart';

void main() {
  group('Provider', () {
    PrepTimeProvider provider;
    List<Event> defaultEvents = [
      Policy.highSchool(),
      LincolnDouglas.highSchool(),
      PublicForum.highSchool(),
    ];
    PlatformInfo defaultPlatformInfo = PlatformInfo(
      isAndroid: Platform.isAndroid,
      isIOS: Platform.isIOS,
    );
    setUp(() {
      provider = PrepTimeProvider(
        child: Placeholder(),
      );
    });
    test('builds default platform info if param is null', () {
      expect(provider.platformInfo, equals(defaultPlatformInfo));
    });
    test('builds default events if param is null', () {
      expect(provider.eventController.events, equals(defaultEvents));
    });
    test('getEventFromController returns the event from the controller', () {
      expect(
        provider.getEventFromController(provider.eventController, null),
        equals(provider.eventController.event),
      );
    });
  });
}
