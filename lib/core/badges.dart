/// Daily 5 numbers the server counts for a person: the streak (days in a row
/// that ends today or yesterday), the best streak, runs with all 5 right and
/// all finished runs.
class DailyStats {
  const DailyStats({
    this.streak = 0,
    this.best = 0,
    this.perfect = 0,
    this.plays = 0,
  });

  final int streak;
  final int best;
  final int perfect;
  final int plays;

  /// Reads the "me_stats" part of the leaderboard answer. Returns null when it
  /// is missing (logged out, or an older server).
  static DailyStats? fromJson(Object? raw) {
    if (raw is! Map) {
      return null;
    }
    int n(Object? v) => v is int ? v : (v is num ? v.toInt() : 0);
    return DailyStats(
      streak: n(raw['streak']),
      best: n(raw['best']),
      perfect: n(raw['perfect']),
      plays: n(raw['plays']),
    );
  }
}

/// One badge, with its name in both languages.
class DailyBadge {
  const DailyBadge(this.id, this.emoji, this.en, this.hi, this.earned);

  final String id;
  final String emoji;
  final String en;
  final String hi;
  final bool earned;
}

/// All badges, earned or not, in a fixed order. The website shows the same ones.
List<DailyBadge> badgesFor(DailyStats s) => <DailyBadge>[
      DailyBadge('first', '🚀', 'First run', 'पहला खेल', s.plays >= 1),
      DailyBadge('s3', '🔥', '3-day streak', '3 दिन की streak', s.best >= 3),
      DailyBadge('s7', '🔥', '7-day streak', '7 दिन की streak', s.best >= 7),
      DailyBadge('s30', '🏆', '30-day streak', '30 दिन की streak', s.best >= 30),
      DailyBadge(
          'perfect', '⭐', 'Perfect 5 of 5', '5 में से 5 सही', s.perfect >= 1),
      DailyBadge('p10', '🪐', '10 runs', '10 खेल', s.plays >= 10),
      DailyBadge('p50', '🌌', '50 runs', '50 खेल', s.plays >= 50),
    ];
