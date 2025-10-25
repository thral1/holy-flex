class Question {
  final String id;
  final String text;
  final List<String> choices;
  final int correctIndex;
  final String? explanation;
  final String category;
  final int difficulty;

  Question({
    required this.id,
    required this.text,
    required this.choices,
    required this.correctIndex,
    this.explanation,
    required this.category,
    this.difficulty = 1,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      text: json['text'] as String,
      choices: List<String>.from(json['choices'] as List),
      correctIndex: json['correctIndex'] as int,
      explanation: json['explanation'] as String?,
      category: json['category'] as String,
      difficulty: json['difficulty'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'choices': choices,
      'correctIndex': correctIndex,
      'explanation': explanation,
      'category': category,
      'difficulty': difficulty,
    };
  }
}
