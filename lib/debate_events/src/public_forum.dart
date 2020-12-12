part of '../debate_events.dart';

/// Defines two pre-assembled Public Forum format debate events.
class PublicForum extends DebateEvent {
  /// Rules for Public Forum Debate.
  static const int _hsConstructive = 4;
  static const int _hsRebuttal = 4;
  static const int _hsSummary = 3;
  static const int _hsFinalFocus = 2;
  static const int _hsPrepTime = 2;
  static const int _hsCrossfire = 3;

  /// High school public forum.
  PublicForum.highSchool()
      : super(
          name: 'HS Public Forum',
          description: '$_hsPrepTime\' Prep',
          speeches: [
            _createSpeech('Cons.', _hsConstructive),
            _createSpeech('Cons.', _hsConstructive),
            _createSpeech('Crossfire', _hsCrossfire),
            _createSpeech('Rebt.', _hsRebuttal),
            _createSpeech('Rebt.', _hsRebuttal),
            _createSpeech('Crossfire', _hsCrossfire),
            _createSpeech('Rebt.', _hsSummary),
            _createSpeech('Rebt.', _hsSummary),
            _createSpeech('Crossfire', _hsCrossfire),
            _createSpeech('Rebt.', _hsFinalFocus),
            _createSpeech('Rebt.', _hsFinalFocus),
          ],
        ) {
    super.initPrepTimers(
      duration: Duration(minutes: _hsPrepTime),
      useAffNeg: false,
    );
  }

  @override
  int get hashCode => 2;

  @override
  bool operator ==(Object other) {
    return this.hashCode == other.hashCode;
  }
}
