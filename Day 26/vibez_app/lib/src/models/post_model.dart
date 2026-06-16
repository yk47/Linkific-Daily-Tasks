import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postId;
  final String userId;
  final String userName;
  final String? userPhotoURL;
  final String? caption;
  final String? imageUrl;
  final DateTime timestamp;
  final int likeCount;
  final int commentCount;
  final List<String> likes;

  PostModel({
    required this.postId,
    required this.userId,
    required this.userName,
    this.userPhotoURL,
    this.caption,
    this.imageUrl,
    DateTime? timestamp,
    this.likeCount = 0,
    this.commentCount = 0,
    this.likes = const [],
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'userId': userId,
      'userName': userName,
      'userPhotoURL': userPhotoURL,
      'caption': caption,
      'imageUrl': imageUrl,
      'timestamp': Timestamp.fromDate(timestamp),
      'likeCount': likeCount,
      'commentCount': commentCount,
      'likes': likes,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      postId: map['postId'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userPhotoURL: map['userPhotoURL'],
      caption: map['caption'],
      imageUrl: map['imageUrl'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      likeCount: map['likeCount'] ?? 0,
      commentCount: map['commentCount'] ?? 0,
      likes: List<String>.from(map['likes'] ?? []),
    );
  }

  PostModel copyWith({
    String? postId,
    String? userId,
    String? userName,
    String? userPhotoURL,
    String? caption,
    String? imageUrl,
    DateTime? timestamp,
    int? likeCount,
    int? commentCount,
    List<String>? likes,
  }) {
    return PostModel(
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userPhotoURL: userPhotoURL ?? this.userPhotoURL,
      caption: caption ?? this.caption,
      imageUrl: imageUrl ?? this.imageUrl,
      timestamp: timestamp ?? this.timestamp,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      likes: likes ?? this.likes,
    );
  }
}

class CommentModel {
  final String commentId;
  final String postId;
  final String userId;
  final String userName;
  final String? userPhotoURL;
  final String content;
  final DateTime timestamp;

  CommentModel({
    required this.commentId,
    required this.postId,
    required this.userId,
    required this.userName,
    this.userPhotoURL,
    required this.content,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'commentId': commentId,
      'postId': postId,
      'userId': userId,
      'userName': userName,
      'userPhotoURL': userPhotoURL,
      'content': content,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      commentId: map['commentId'] ?? '',
      postId: map['postId'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userPhotoURL: map['userPhotoURL'],
      content: map['content'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}