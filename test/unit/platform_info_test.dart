// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

import 'package:flutter_test/flutter_test.dart';
import 'package:preptime/models/platform_info.dart';

void main() {
  group('PlatformInfo', () {
    test('constructor throws assertion error if isIOS is null', () {
      expect(
        () => PlatformInfo(isIOS: null, isAndroid: true),
        throwsAssertionError,
      );
    });
    test('constructor throws assertion error if isAndroid is null', () {
      expect(
        () => PlatformInfo(isAndroid: null, isIOS: true),
        throwsAssertionError,
      );
    });
    test('isIOS and isAndroid getters use constructed values', () {
      PlatformInfo platformInfo = PlatformInfo(isAndroid: true, isIOS: false);
      expect(platformInfo.isAndroid, isTrue);
      expect(platformInfo.isIOS, isFalse);
    });
    test('iOS named constructor sets platform to iOS', () {
      PlatformInfo platformInfo = PlatformInfo.iOS();
      expect(platformInfo.isIOS, isTrue);
      expect(platformInfo.isAndroid, isFalse);
    });
    test('android named constructor sets platform to Android', () {
      PlatformInfo platformInfo = PlatformInfo.android();
      expect(platformInfo.isAndroid, isTrue);
      expect(platformInfo.isIOS, isFalse);
    });
  });
}
