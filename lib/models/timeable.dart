/// An interface that defines a timeable class.
/// 
/// A [Timeable] class must have an internal timer where the client can check
/// if that timer [isRunning] or [isNotRunning], as well as [stop], [resume],
/// and [reset] the timer to its initial value.
abstract class Timeable {
  /// Whether the timer is running.
  bool get isRunning;
  
  /// Whether the timer is not running.
  bool get isNotRunning;

  /// Resumes the timer.
  void resume();

  /// Stops the timer.
  void stop();

  /// Resets the timer.
  void reset();
}
