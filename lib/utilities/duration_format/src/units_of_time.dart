// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

// coverage:ignore-file

// TODO: #22 Finish durationFormatting package.
enum UnitsOfTime {
  /// 100 [calendarYears]
  centuries,

  /// 10 [calendarYears]
  decades,
  
  /// Defined as the time between two successive occurences of the vernal
  /// equinox, this is equal to 365 [days], 5 [hours], 48 [minutes], and 46
  /// [seconds].
  solarYears,

  /// 365 [days]
  calendarYears,

  /// 30.436875 [days]
  gregorianMonths,

  /// 30 [days]
  fiscalMonths,

  /// 7 [days]
  weeks,

  /// Defined as exactly 86,400 [seconds]
  days,

  /// 60 [minutes]
  hours,

  /// 60 [seconds]
  minutes,

  /// Since 1967, one second is exactly "the duration of 9,192,631,770 periods
  /// of the radiation corresponding to the transition between the two
  /// hyperfine levels of the ground state of the caesium-133 atom" (at a
  /// temperature of zero Kelvin).
  /// 
  /// See: https://wikipedia.org/wiki/Second
  seconds,

  /// 1,000th (thousandth) of a [second]
  milliseconds,

  /// 1,000,000th (millionth) of a [second]
  microsecond,

  /// 1,000,000,000th (billionth) of a [second]
  nanosecond,
}
