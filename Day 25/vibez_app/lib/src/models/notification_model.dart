import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationType {
  like,
  comment,
  follow,
  mention,
}

class NotificationModel {
  final String notificationId;
  final String userId;
  final String fromUserId;
  final String fromUserName;
  final String? fromUserPhotoURL;
  final NotificationType type;
  final String? postId;
  final String? message;
  final bool read;
  final DateTime timestamp;

  NotificationModel({
    required this.notificationId,
    required this.userId,
    required this.fromUserId,
    required this.fromUserName,
    this.fromUserPhotoURL,
    required this.type,
    this.postId,
    this.message,
    this.read = false,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'notificationId': notificationId,
      'userId': userId,
      'fromUserId': fromUserId,
      'fromUserName': fromUserName,
      'fromUserPhotoURL': fromUserPhotoURL,
      'type': type.name,
      'postId': postId,
      'message': message,
      'read': read,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      notificationId: map['notificationId'] ?? '',
      userId: map['userId'] ?? '',
      fromUserId: map['fromUserId'] ?? '',
      fromUserName: map['fromUserName'] ?? '',
      fromUserPhotoURL: map['fromUserPhotoURL'],
      type: NotificationType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => NotificationType.like,
      ),
      postId: map['postId'],
      message: map['message'],
      read: map['read'] ?? false,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  String get displayText {
    switch (type) {
      case NotificationType.like:
        return 'liked your post';
      case NotificationType.comment:
        return 'commented: "$message"';
      case NotificationType.follow:
        return 'started following you';
      case NotificationType.mention:
        return 'mentioned you in a post';
    }
  }
}