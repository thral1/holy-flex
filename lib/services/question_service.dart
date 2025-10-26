import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/question.dart';

class QuestionService {
  final Map<String, List<Question>> _cache = {};

  static const String _samuel17Path = 'lib/data/samuel_17_questions.json';
  static const List<String> _samuel17TempQuestionIds = [
    'samuel17_q1',
    'samuel17_q5',
    'samuel17_q9',
  ];

  Future<List<Question>> loadQuestions(String levelId) async {
    if (_cache.containsKey(levelId)) {
      return _cache[levelId]!;
    }

    try {
      final String jsonString = await rootBundle.loadString(levelId);
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> questionsJson = jsonData['questions'] as List;

      var questions = questionsJson
          .map((q) => Question.fromJson(q as Map<String, dynamic>))
          .toList();

      if (levelId == _samuel17Path) {
        questions = questions
            .where((q) => _samuel17TempQuestionIds.contains(q.id))
            .toList();
      }

      _cache[levelId] = questions;
      return questions;
    } catch (e) {
      throw Exception('Failed to load questions: $e');
    }
  }

  List<Question> shuffleQuestions(List<Question> questions) {
    final shuffled = List<Question>.from(questions);
    shuffled.shuffle();
    return shuffled;
  }

  void clearCache() {
    _cache.clear();
  }
}
