enum ChatType {
  individual,
  group,
}

enum MessageType {
  text,
  image,
  file,
  system,
}

class ChatModel {
  final String chatId;
  final ChatType chatType;
  final String? groupName;
  final String? groupImage;
  final String? groupDescription;
  final List<String> participants;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final String? lastMessageSenderId;
  final MessageType? lastMessageType;
  final Map<String, int> unreadCount;
  final String? createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatModel({
    required this.chatId,
    required this.chatType,
    this.groupName,
    this.groupImage,
    this.groupDescription,
    required this.participants,
    this.lastMessage,
    this.lastMessageTime,
    this.lastMessageSenderId,
    this.lastMessageType,
    this.unreadCount = const {},
    this.createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'chatType': chatType.name,
      'groupName': groupName,
      'groupImage': groupImage,
      'groupDescription': groupDescription,
      'participants': participants,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime?.millisecondsSinceEpoch,
      'lastMessageSenderId': lastMessageSenderId,
      'lastMessageType': lastMessageType?.name,
      'unreadCount': unreadCount,
      'createdBy': createdBy,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      chatId: map['chatId'] ?? '',
      chatType: ChatType.values.firstWhere(
        (e) => e.name == map['chatType'],
        orElse: () => ChatType.individual,
      ),
      groupName: map['groupName'],
      groupImage: map['groupImage'],
      groupDescription: map['groupDescription'],
      participants: List<String>.from(map['participants'] ?? []),
      lastMessage: map['lastMessage'],
      lastMessageTime: map['lastMessageTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastMessageTime'])
          : null,
      lastMessageSenderId: map['lastMessageSenderId'],
      lastMessageType: map['lastMessageType'] != null
          ? MessageType.values.firstWhere(
              (e) => e.name == map['lastMessageType'],
              orElse: () => MessageType.text,
            )
          : null,
      unreadCount: Map<String, int>.from(map['unreadCount'] ?? {}),
      createdBy: map['createdBy'],
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'])
          : DateTime.now(),
    );
  }

  ChatModel copyWith({
    String? chatId,
    ChatType? chatType,
    String? groupName,
    String? groupImage,
    String? groupDescription,
    List<String>? participants,
    String? lastMessage,
    DateTime? lastMessageTime,
    String? lastMessageSenderId,
    MessageType? lastMessageType,
    Map<String, int>? unreadCount,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChatModel(
      chatId: chatId ?? this.chatId,
      chatType: chatType ?? this.chatType,
      groupName: groupName ?? this.groupName,
      groupImage: groupImage ?? this.groupImage,
      groupDescription: groupDescription ?? this.groupDescription,
      participants: participants ?? this.participants,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      lastMessageSenderId: lastMessageSenderId ?? this.lastMessageSenderId,
      lastMessageType: lastMessageType ?? this.lastMessageType,
      unreadCount: unreadCount ?? this.unreadCount,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}