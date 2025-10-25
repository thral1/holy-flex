class QuestionResult {
  final String questionId;
  final int selectedIndex;
  final bool isCorrect;
  final int timeSpentMs;
  final int pointsEarned;

  QuestionResult({
    required this.questionId,
    required this.selectedIndex,
    required this.isCorrect,
    required this.timeSpentMs,
    required this.pointsEarned,
  });

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'selectedIndex': selectedIndex,
      'isCorrect': isCorrect,
      'timeSpentMs': timeSpentMs,
      'pointsEarned': pointsEarned,
    };
  }

  factory QuestionResult.fromJson(Map<String, dynamic> json) {
    return QuestionResult(
      questionId: json['questionId'] as String,
      selectedIndex: json['selectedIndex'] as int,
      isCorrect: json['isCorrect'] as bool,
      timeSpentMs: json['timeSpentMs'] as int,
      pointsEarned: json['pointsEarned'] as int,
    );
  }
}
