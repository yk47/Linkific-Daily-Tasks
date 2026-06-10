import 'package:hive/hive.dart';

class QuizResult extends HiveObject {
  final String category;
  final int score;
  final int totalQuestions;
  final DateTime date;
  final double accuracy;

  QuizResult({
    required this.category,
    required this.score,
    required this.totalQuestions,
    required this.date,
    required this.accuracy,
  });

  Map<String, dynamic> toJson() => {
        'category': category,
        'score': score,
        'totalQuestions': totalQuestions,
        'date': date.toIso8601String(),
        'accuracy': accuracy,
      };

  factory QuizResult.fromJson(Map<String, dynamic> json) => QuizResult(
        category: json['category'] as String,
        score: json['score'] as int,
        totalQuestions: json['totalQuestions'] as int,
        date: DateTime.parse(json['date'] as String),
        accuracy: (json['accuracy'] as num).toDouble(),
      );
}

class QuizResultAdapter extends TypeAdapter<QuizResult> {
  @override
  final int typeId = 0;

  @override
  QuizResult read(BinaryReader reader) {
    final numFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numFields; i++) {
      final key = reader.readByte();
      final value = reader.read();
      fields[key] = value;
    }
    return QuizResult(
      category: fields[0] as String,
      score: fields[1] as int,
      totalQuestions: fields[2] as int,
      date: DateTime.fromMillisecondsSinceEpoch(fields[3] as int),
      accuracy: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, QuizResult obj) {
    writer.writeByte(5);
    writer.writeByte(0);
    writer.writeString(obj.category);
    writer.writeByte(1);
    writer.writeInt(obj.score);
    writer.writeByte(2);
    writer.writeInt(obj.totalQuestions);
    writer.writeByte(3);
    writer.writeInt(obj.date.millisecondsSinceEpoch);
    writer.writeByte(4);
    writer.writeDouble(obj.accuracy);
  }
}