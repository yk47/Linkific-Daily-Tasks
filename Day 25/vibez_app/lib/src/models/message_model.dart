import 'chat_model.dart';

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
}

class MessageModel {
  final String messageId;
  final String chatId;
  final String senderId;
  final String senderName;
  final String? senderPhotoURL;
  final String content;
  final MessageType type;
  final MessageStatus status;
  final DateTime timestamp;
  final DateTime? editedAt;
  final String? imageUrl;
  final String? fileName;
  final String? fileSize;
  final String? replyToMessageId;
  final String? replyToContent;
  final String? replyToSenderName;
  final List<String> readBy;
  final bool isDeleted;
  final bool isForwarded;

  MessageModel({
    required this.messageId,
    required this.chatId,
    required this.senderId,
    required this.senderName,
    this.senderPhotoURL,
    required this.content,
    this.type = MessageType.text,
    this.status = MessageStatus.sent,
    DateTime? timestamp,
    this.editedAt,
    this.imageUrl,
    this.fileName,
    this.fileSize,
    this.replyToMessageId,
    this.replyToContent,
    this.replyToSenderName,
    this.readBy = const [],
    this.isDeleted = false,
    this.isForwarded = false,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'chatId': chatId,
      'senderId': senderId,
      'senderName': senderName,
      'senderPhotoURL': senderPhotoURL,
      'content': content,
      'type': type.name,
      'status': status.name,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'editedAt': editedAt?.millisecondsSinceEpoch,
      'imageUrl': imageUrl,
      'fileName': fileName,
      'fileSize': fileSize,
      'replyToMessageId': replyToMessageId,
      'replyToContent': replyToContent,
      'replyToSenderName': replyToSenderName,
      'readBy': readBy,
      'isDeleted': isDeleted,
      'isForwarded': isForwarded,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      messageId: map['messageId'] ?? '',
      chatId: map['chatId'] ?? '',
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? '',
      senderPhotoURL: map['senderPhotoURL'],
      content: map['content'] ?? '',
      type: MessageType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => MessageType.text,
      ),
      status: MessageStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => MessageStatus.sent,
      ),
      timestamp: map['timestamp'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['timestamp'])
          : DateTime.now(),
      editedAt: map['editedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['editedAt'])
          : null,
      imageUrl: map['imageUrl'],
      fileName: map['fileName'],
      fileSize: map['fileSize'],
      replyToMessageId: map['replyToMessageId'],
      replyToContent: map['replyToContent'],
      replyToSenderName: map['replyToSenderName'],
      readBy: List<String>.from(map['readBy'] ?? []),
      isDeleted: map['isDeleted'] ?? false,
      isForwarded: map['isForwarded'] ?? false,
    );
  }

  MessageModel copyWith({
    String? messageId,
    String? chatId,
    String? senderId,
    String? senderName,
    String? senderPhotoURL,
    String? content,
    MessageType? type,
    MessageStatus? status,
    DateTime? timestamp,
    DateTime? editedAt,
    String? imageUrl,
    String? fileName,
    String? fileSize,
    String? replyToMessageId,
    String? replyToContent,
    String? replyToSenderName,
    List<String>? readBy,
    bool? isDeleted,
    bool? isForwarded,
  }) {
    return MessageModel(
      messageId: messageId ?? this.messageId,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderPhotoURL: senderPhotoURL ?? this.senderPhotoURL,
      content: content ?? this.content,
      type: type ?? this.type,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      editedAt: editedAt ?? this.editedAt,
      imageUrl: imageUrl ?? this.imageUrl,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      replyToContent: replyToContent ?? this.replyToContent,
      replyToSenderName: replyToSenderName ?? this.replyToSenderName,
      readBy: readBy ?? this.readBy,
      isDeleted: isDeleted ?? this.isDeleted,
      isForwarded: isForwarded ?? this.isForwarded,
    );
  }

  String get formattedTime {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String get statusIcon {
    switch (status) {
      case MessageStatus.sending:
        return '⏳';
      case MessageStatus.sent:
        return '✓';
      case MessageStatus.delivered:
        return '✓✓';
      case MessageStatus.read:
        return '✓✓';
      case MessageStatus.failed:
        return '⚠️';
    }
  }
}