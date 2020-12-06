/// A Debate Team.
///
/// There are two kinds of team. A left team and a right team.
enum Team {
  /// The team that sits on the left.
  left,

  /// The team that sits on the right.
  right,
}

/// Extends the Team enum with string formatting rules.
extension StringFormatting on Team {
  /// Returns the team name as a formatted string.index
  ///
  /// If [useAffNeg] is true, the left team is `AFF` and the right team is
  /// `NEG`. Otherwise, the left team is `PRO` and the right team is `CON`.
  String toFormattedString(bool useAffNeg) {
    if (useAffNeg) return this.index == 0 ? 'AFF' : 'NEG';
    return this.index == 0 ? 'PRO' : 'CON';
  }
}
