part of '../debate_events.dart';

/// Defines a list of basic policy debate speeches.
class Policy extends DebateEvent {
  /// Middle School Policy Debate.
  static const int _msConstructive = 4;
  static const int _msRebuttal = 2;
  static const int _msPrepTime = 6;
  static const int _msCrossX = 2;

  /// High School Policy Debate.
  static const int _hsConstructive = 8;
  static const int _hsRebuttal = 5;
  static const int _hsPrepTime = 8;
  static const int _hsCrossX = 3;

  /// University Policy Debate.
  static const int _univConstructive = 9;
  static const int _univPrepTime = 10;
  static const int _univRebuttal = 6;
  static const int _univCrossX = 3;

  /// The NSDA Default times for middle school policy debate.
  Policy.middleSchool()
      : super(
          name: 'MS Policy Debate',
          description: '$_msPrepTime\' Prep',
          speeches: [
            _createSpeech('1AC', _msConstructive),
            _createSpeech('CX', _msCrossX),
            _createSpeech('1NC', _msConstructive),
            _createSpeech('CX', _msCrossX),
            _createSpeech('2AC', _msConstructive),
            _createSpeech('CX', _msCrossX),
            _createSpeech('2NC', _msConstructive),
            _createSpeech('CX', _msCrossX),
            _createSpeech('1NR', _msRebuttal),
            _createSpeech('1AR', _msRebuttal),
            _createSpeech('2NR', _msRebuttal),
            _createSpeech('2AR', _msRebuttal),
          ],
        ) {
    super.initPrepTimers(
      duration: Duration(minutes: _msPrepTime),
      useAffNeg: true,
    );
  }

  /// The NSDA Default times for high school policy debate.
  Policy.highSchool()
      : super(
          name: 'HS Policy Debate',
          description: '$_hsPrepTime\' Prep',
          speeches: [
            _createSpeech('1AC', _hsConstructive),
            _createSpeech('CX', _hsCrossX),
            _createSpeech('1NC', _hsConstructive),
            _createSpeech('CX', _hsCrossX),
            _createSpeech('2AC', _hsConstructive),
            _createSpeech('CX', _hsCrossX),
            _createSpeech('2NC', _hsConstructive),
            _createSpeech('CX', _hsCrossX),
            _createSpeech('1NR', _hsRebuttal),
            _createSpeech('1AR', _hsRebuttal),
            _createSpeech('2NR', _hsRebuttal),
            _createSpeech('2AR', _hsRebuttal),
          ],
        ) {
    super.initPrepTimers(
      duration: Duration(seconds: _hsPrepTime), // TODO(Justin): FIX this!!!!!!
      useAffNeg: true,
    );
  }

  /// The NSDA Default times for university policy debate.
  Policy.college()
      : super(
          name: 'College Policy Debate',
          description: '$_univPrepTime\' Prep',
          speeches: [
            _createSpeech('1AC', _univConstructive),
            _createSpeech('CX', _univCrossX),
            _createSpeech('1NC', _univConstructive),
            _createSpeech('CX', _univCrossX),
            _createSpeech('2AC', _univConstructive),
            _createSpeech('CX', _univCrossX),
            _createSpeech('2NC', _univConstructive),
            _createSpeech('CX', _univCrossX),
            _createSpeech('1NR', _univRebuttal),
            _createSpeech('1AR', _univRebuttal),
            _createSpeech('2NR', _univRebuttal),
            _createSpeech('2AR', _univRebuttal),
          ],
        ) {
    super.initPrepTimers(
      duration: Duration(minutes: _univPrepTime),
      useAffNeg: true,
    );
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Policy && this.hashCode == other.hashCode;
  }
}
