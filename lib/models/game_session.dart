import 'question_result.dart';

class GameSession {
  final String sessionId;
  final String userId;
  final String levelId;
  int currentQuestionIndex;
  int correctAnswers;
  int totalScore;
  List<QuestionResult> results;
  final DateTime startTime;
  DateTime? endTime;

  GameSession({
    required this.sessionId,
    required this.userId,
    required this.levelId,
    this.currentQuestionIndex = 0,
    this.correctAnswers = 0,
    this.totalScore = 0,
    List<QuestionResult>? results,
    required this.startTime,
    this.endTime,
  }) : results = results ?? [];

  void addResult(QuestionResult result) {
    results.add(result);
    if (result.isCorrect) {
      correctAnswers++;
    }
    totalScore += result.pointsEarned;
    currentQuestionIndex++;
  }

  void complete() {
    endTime = DateTime.now();
  }

  bool get isComplete => endTime != null;

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'userId': userId,
      'levelId': levelId,
      'currentQuestionIndex': currentQuestionIndex,
      'correctAnswers': correctAnswers,
      'totalScore': totalScore,
      'results': results.map((r) => r.toJson()).toList(),
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
    };
  }

  factory GameSession.fromJson(Map<String, dynamic> json) {
    return GameSession(
      sessionId: json['sessionId'] as String,
      userId: json['userId'] as String,
      levelId: json['levelId'] as String,
      currentQuestionIndex: json['currentQuestionIndex'] as int,
      correctAnswers: json['correctAnswers'] as int,
      totalScore: json['totalScore'] as int,
      results: (json['results'] as List)
          .map((r) => QuestionResult.fromJson(r as Map<String, dynamic>))
          .toList(),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : null,
    );
  }
}
