// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

/// Extends the Duration class to include a simple check if this duration is
/// equal to either the given number of minutes or the given number of seconds.
extension MinutesOrSeconds on Duration {
  /// Returns whether the given duration equals the given number of minutes or
  /// the given number of seconds.
  ///
  /// For example,
  ///
  /// ```dart
  /// Duration fiveSeconds = Duration(seconds: 5);
  /// Duration fiveMinutes = Duration(minutes: 5);
  /// Duration tenMinutes = Duration(minutes: 10);
  /// fiveSeconds.equalsMinutesOrSeconds(5) // true
  /// fiveMinutes.equalsMinutesOrSeconds(5) // true
  /// tenMinutes.equalsMinutesOrSeconds(5) // false
  /// ```
  bool equalsMinutesOrSeconds(int value) {
    return this == Duration(minutes: value) || this == Duration(seconds: value);
  }

  /// Returns whether the duration is best measured in minutes or seconds. If
  /// it is best measured in neither, it returns "neither".
  ///
  /// Returns "Minute", "Second", or "Neither".
  String isMinutesOrSeconds() {
    if (this >= const Duration(minutes: 1) && this < const Duration(hours: 1)) {
      return 'Minute';
    } else if (this >= const Duration(seconds: 1) &&
        this < const Duration(minutes: 1)) {
      return 'Second';
    } else {
      return 'Neither';
    }
  }
}
