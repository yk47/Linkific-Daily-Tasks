class Question {
  final int id;
  final String category;
  final String questionText;
  final List<String> options;
  final int correctIndex;
  final String? explanation;

  const Question({
    required this.id,
    required this.category,
    required this.questionText,
    required this.options,
    required this.correctIndex,
    this.explanation,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'questionText': questionText,
        'options': options,
        'correctIndex': correctIndex,
        'explanation': explanation,
      };

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json['id'] as int,
        category: json['category'] as String,
        questionText: json['questionText'] as String,
        options: (json['options'] as List).cast<String>(),
        correctIndex: json['correctIndex'] as int,
        explanation: json['explanation'] as String?,
      );
}