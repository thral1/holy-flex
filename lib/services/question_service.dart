import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/question.dart';

class QuestionService {
  final Map<String, List<Question>> _cache = {};

  static const String _samuel17Path = 'lib/data/samuel_17_questions.json';
  static const List<String> _samuel17TempQuestionIds = [
    'samuel17_q5', // Goliath's core boast...
    'samuel17_q1', // What problem most deeply offends David...
    'samuel17_q9', // David calls Israel...
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
        // Maintain specific order for David and Goliath questions
        final orderedQuestions = <Question>[];
        for (final id in _samuel17TempQuestionIds) {
          final question = questions.firstWhere((q) => q.id == id);
          orderedQuestions.add(question);
        }
        questions = orderedQuestions;
      }

      _cache[levelId] = questions;
      return questions;
    } catch (e) {
      throw Exception('Failed to load questions: $e');
    }
  }

  List<Question> shuffleQuestions(List<Question> questions) {
    // Don't shuffle David and Goliath questions - they have a specific order
    if (questions.length == 3 &&
        questions.any((q) => q.id == 'samuel17_q5') &&
        questions.any((q) => q.id == 'samuel17_q1') &&
        questions.any((q) => q.id == 'samuel17_q9')) {
      return questions;
    }

    final shuffled = List<Question>.from(questions);
    shuffled.shuffle();
    return shuffled;
  }

  void clearCache() {
    _cache.clear();
  }
}
