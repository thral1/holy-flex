import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/question.dart';

class QuestionService {
  List<Question>? _cachedQuestions;

  Future<List<Question>> loadQuestions(String levelId) async {
    if (_cachedQuestions != null) {
      return _cachedQuestions!;
    }

    try {
      final String jsonString =
          await rootBundle.loadString('lib/data/genesis_questions.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> questionsJson = jsonData['questions'] as List;

      _cachedQuestions = questionsJson
          .map((q) => Question.fromJson(q as Map<String, dynamic>))
          .toList();

      return _cachedQuestions!;
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
    _cachedQuestions = null;
  }
}
