/// The status of a button.
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