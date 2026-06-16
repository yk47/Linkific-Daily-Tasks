import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../config/app_config.dart';
import '../models/post_model.dart';
import '../models/notification_model.dart';
import 'firebase_service.dart';

class SocialService {
  final FirebaseService _firebaseService = FirebaseService();
  final _uuid = const Uuid();

  FirebaseFirestore get _firestore => _firebaseService.firestore;
  FirebaseStorage get _storage => _firebaseService.storage;

  // ==================== FEED & POSTS ====================

  Stream<List<PostModel>> streamFeedPosts() {
    return _firestore
        .collection(AppConfig.postsCollection)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return PostModel.fromMap(doc.data());
      }).toList();
    });
  }

  Stream<List<PostModel>> streamUserPosts(String userId) {
    return _firestore
        .collection(AppConfig.postsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return PostModel.fromMap(doc.data());
      }).toList();
    });
  }

  Future<void> createPost({
    required String userId,
    required String userName,
    String? userPhotoURL,
    String? caption,
    File? imageFile,
  }) async {
    final postId = _uuid.v4();
    String? imageUrl;

    if (imageFile != null) {
      imageUrl = await _uploadImage(imageFile, 'posts/$postId');
    }

    final post = PostModel(
      postId: postId,
      userId: userId,
      userName: userName,
      userPhotoURL: userPhotoURL,
      caption: caption,
      imageUrl: imageUrl,
      timestamp: DateTime.now(),
    );

    await _firestore
        .collection(AppConfig.postsCollection)
        .doc(postId)
        .set(post.toMap());
  }

  // ==================== LIKES ====================

  Future<void> toggleLike({
    required String postId,
    required String userId,
    required String postOwnerId,
    required String postOwnerName,
  }) async {
    final postRef = _firestore.collection(AppConfig.postsCollection).doc(postId);

    await _firestore.runTransaction((transaction) async {
      final postSnapshot = await transaction.get(postRef);
      if (!postSnapshot.exists) return;

      final data = postSnapshot.data()!;
      final likes = List<String>.from(data['likes'] ?? []);

      if (likes.contains(userId)) {
        likes.remove(userId);
      } else {
        likes.add(userId);
        
        if (postOwnerId != userId) {
          await _createNotification(
            userId: postOwnerId,
            fromUserId: userId,
            fromUserName: postOwnerName,
            type: NotificationType.like,
            postId: postId,
          );
        }
      }

      transaction.update(postRef, {
        'likes': likes,
        'likeCount': likes.length,
      });
    });
  }

  // ==================== COMMENTS ====================

  Stream<List<CommentModel>> streamComments(String postId) {
    return _firestore
        .collection(AppConfig.postsCollection)
        .doc(postId)
        .collection('comments')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return CommentModel.fromMap(doc.data());
      }).toList();
    });
  }

  Future<void> addComment({
    required String postId,
    required String userId,
    required String userName,
    String? userPhotoURL,
    required String content,
    required String postOwnerId,
  }) async {
    final commentId = _uuid.v4();

    final comment = CommentModel(
      commentId: commentId,
      postId: postId,
      userId: userId,
      userName: userName,
      userPhotoURL: userPhotoURL,
      content: content,
      timestamp: DateTime.now(),
    );

    await _firestore
        .collection(AppConfig.postsCollection)
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .set(comment.toMap());

    await _firestore
        .collection(AppConfig.postsCollection)
        .doc(postId)
        .update({'commentCount': FieldValue.increment(1)});

    if (postOwnerId != userId) {
      await _createNotification(
        userId: postOwnerId,
        fromUserId: userId,
        fromUserName: userName,
        type: NotificationType.comment,
        postId: postId,
        message: content,
      );
    }
  }

  // ==================== FOLLOWS ====================

  Future<void> toggleFollow({
    required String currentUserId,
    required String targetUserId,
  }) async {
    final followRef = _firestore
        .collection(AppConfig.usersCollection)
        .doc(currentUserId)
        .collection('following')
        .doc(targetUserId);

    final docSnapshot = await followRef.get();

    if (docSnapshot.exists) {
      await followRef.delete();
    } else {
      await followRef.set({
        'followedUserId': targetUserId,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<bool> isFollowing(String currentUserId, String targetUserId) async {
    final followRef = _firestore
        .collection(AppConfig.usersCollection)
        .doc(currentUserId)
        .collection('following')
        .doc(targetUserId);

    final docSnapshot = await followRef.get();
    return docSnapshot.exists;
  }

  Stream<int> streamFollowersCount(String userId) {
    return _firestore
        .collection(AppConfig.usersCollection)
        .doc(userId)
        .collection('following')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Stream<int> streamFollowingCount(String userId) {
    return _firestore
        .collection(AppConfig.usersCollection)
        .doc(userId)
        .collection('following')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // ==================== NOTIFICATIONS ====================

  Stream<List<NotificationModel>> streamNotifications(String userId) {
    return _firestore
        .collection(AppConfig.usersCollection)
        .doc(userId)
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return NotificationModel.fromMap(doc.data());
      }).toList();
    });
  }

  Stream<int> streamUnreadNotificationCount(String userId) {
    return _firestore
        .collection(AppConfig.usersCollection)
        .doc(userId)
        .collection('notifications')
        .where('read', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    // This needs userId context to find the notification
  }

  Future<void> _createNotification({
    required String userId,
    required String fromUserId,
    required String fromUserName,
    String? fromUserPhotoURL,
    required NotificationType type,
    String? postId,
    String? message,
  }) async {
    final notificationId = _uuid.v4();
    final notification = NotificationModel(
      notificationId: notificationId,
      userId: userId,
      fromUserId: fromUserId,
      fromUserName: fromUserName,
      fromUserPhotoURL: fromUserPhotoURL,
      type: type,
      postId: postId,
      message: message,
    );

    await _firestore
        .collection(AppConfig.usersCollection)
        .doc(userId)
        .collection('notifications')
        .doc(notificationId)
        .set(notification.toMap());
  }

  // ==================== HELPERS ====================

  Future<String> _uploadImage(File imageFile, String path) async {
    final ref = _storage.ref().child(path);
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }
}