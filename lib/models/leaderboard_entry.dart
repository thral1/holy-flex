class LeaderboardEntry {
  final String userId;
  final String username;
  final int score;
  final String levelId;
  final DateTime completedAt;

  LeaderboardEntry({
    required this.userId,
    required this.username,
    required this.score,
    required this.levelId,
    required this.completedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'score': score,
      'levelId': levelId,
      'completedAt': completedAt.toIso8601String(),
    };
  }

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      userId: json['userId'] as String,
      username: json['username'] as String,
      score: json['score'] as int,
      levelId: json['levelId'] as String,
      completedAt: DateTime.parse(json['completedAt'] as String),
    );
  }
}
