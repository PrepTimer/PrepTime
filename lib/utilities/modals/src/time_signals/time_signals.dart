/// Enumerates the various time signals given in a speech or debate round.
enum TimeSignal {
  /// Five fingers.
  five,

  /// Four fingers.
  four,

  /// Three fingers.
  three,

  /// Two fingers.
  two,

  /// One finger.
  one,

  /// Sign language "C" (thirty seconds left).
  thirty,

  /// Sign language "H" (fifteen seconds left).
  fifteen,

  /// Zero fingers (time's up).
  fist,
}

extension Stringify on TimeSignal {
  /// Returns the value as a short string.
  ///
  /// For example, instead of returning "TimeSignal.four" this method will only
  /// return the value "four".
  String toShortString() {
    String longString = this.toString();
    int indexOfDot = longString.indexOf('.');
    String shortString = longString.substring(indexOfDot + 1);
    return shortString;
  }
}
