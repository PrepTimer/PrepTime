// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

library duration_formatting;

/// Extends the Duration class with string formatting rules.
extension stringFormatting on Duration {
  /// Returns a clock-like, string-representation of `this`.
  ///
  /// For example,
  /// ```dart
  /// Duration foo = Duration(minutes: 10, milliseconds: 100);
  /// foo.toStringAsClock(); // 10:00.1
  /// ```
  ///
  /// If the number of minutes is less than 10, the minutes is a signle digit.
  /// ```dart
  /// Duration foo = Duration(seconds: 90);
  /// foo.toStringAsClock(); // 1:30.0
  /// ```
  String toStringAsClock() {
    int minutes = this.inMinutes.remainder(Duration.minutesPerHour);
    int seconds = this.inSeconds.remainder(Duration.secondsPerMinute);
    int ms = this.inMilliseconds.remainder(Duration.millisecondsPerSecond);
    String mm = _twoDigitsOf(minutes);
    String ss = _twoDigitsOf(seconds);
    String m = _oneDigitOf(ms);
    return "$mm:$ss.$m";
  }

  String _oneDigitOf(int number) {
    String numberAsSingleDigit = '';
    if (number < 100) {
      numberAsSingleDigit = "0";
    } else {
      numberAsSingleDigit = "${number ~/ 100}";
    }
    assert(numberAsSingleDigit.length == 1);
    return numberAsSingleDigit;
  }

  String _twoDigitsOf(int number) {
    String numberAsTwoDigits = '';
    if (number >= 10) {
      numberAsTwoDigits = "$number";
    } else {
      numberAsTwoDigits = "0$number";
    }
    assert(numberAsTwoDigits.length == 2);
    return numberAsTwoDigits;
  }
}
