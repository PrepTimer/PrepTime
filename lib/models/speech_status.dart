// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

/// The status of a button.
///
/// Values:
/// - [0] => [stoppedAtBeginning]
/// - [1] => [runningForward]
/// - [2] => [pausedInMiddle]
/// - [3] => [completed]
enum SpeechStatus {
  /// The animation is stopped at the beginning.
  stoppedAtBeginning,

  /// The animation is running from beginning to end.
  runningForward,

  /// The animation is stopped in the middle.
  pausedInMiddle,

  /// The animation is stopped at the end.
  completed,
}
