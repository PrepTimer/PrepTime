// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

/// Tracks whether the current platform is Android or iOS.
class PlatformInfo {
  /// Whether the operating system is a version of iOS.
  final bool isIOS;

  /// Whether the operating system is a version of Android.
  final bool isAndroid;

  /// Creates a new PlatformInfo using both the iOS and Android parameters.
  PlatformInfo({this.isAndroid, this.isIOS})
      : assert(isAndroid != null),
        assert(isIOS != null);
}
