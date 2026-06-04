class MessageModel {
  final int id;
  final String senderId;
  final String message;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.message,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as int,
      senderId: json['sender_id'] as String,
      message: json['message'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'message': message,
      'created_at': createdAt.toIso8601String(),
    };
  }

  MessageModel copyWith({
    int? id,
    String? senderId,
    String? message,
    DateTime? createdAt,
  }) {
    return MessageModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'MessageModel(id: $id, senderId: $senderId, message: $message)';
  }
}
