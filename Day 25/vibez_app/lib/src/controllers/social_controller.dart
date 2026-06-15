import 'dart:io';
import 'package:get/get.dart';
import '../models/post_model.dart';
import '../models/notification_model.dart';
import '../services/social_service.dart';
import '../services/auth_service.dart';

class SocialController extends GetxController {
  final SocialService _socialService = SocialService();
  final AuthService _authService = AuthService();

  final RxList<PostModel> feedPosts = RxList<PostModel>();
  final RxList<PostModel> userPosts = RxList<PostModel>();
  final RxList<CommentModel> comments = RxList<CommentModel>();
  final RxList<NotificationModel> notifications = RxList<NotificationModel>();
  final RxInt unreadNotifications = RxInt(0);
  final RxBool isFollowing = RxBool(false);
  final RxInt followersCount = RxInt(0);
  final RxInt followingCount = RxInt(0);
  final RxBool isLoading = RxBool(false);
  final Rx<String?> errorMessage = Rx<String?>(null);

  // ==================== FEED ====================

  void startListeningToFeed() {
    _socialService.streamFeedPosts().listen((posts) {
      feedPosts.assignAll(posts);
    });
  }

  void startListeningToUserPosts(String userId) {
    _socialService.streamUserPosts(userId).listen((posts) {
      userPosts.assignAll(posts);
    });
  }

  // ==================== POSTS ====================

  Future<void> createPost({
    String? caption,
    File? imageFile,
  }) async {
    final user = _authService.currentUserModel;
    if (user == null) return;

    isLoading.value = true;

    try {
      await _socialService.createPost(
        userId: user.uid,
        userName: user.displayName,
        userPhotoURL: user.photoURL,
        caption: caption,
        imageFile: imageFile,
      );
    } catch (e) {
      errorMessage.value = 'Failed to create post';
    }

    isLoading.value = false;
  }

  // ==================== LIKES ====================

  Future<void> toggleLike(String postId, String postOwnerId) async {
    final user = _authService.currentUserModel;
    if (user == null) return;

    await _socialService.toggleLike(
      postId: postId,
      userId: user.uid,
      postOwnerId: postOwnerId,
      postOwnerName: user.displayName,
    );
  }

  // ==================== COMMENTS ====================

  void startListeningToComments(String postId) {
    _socialService.streamComments(postId).listen((commentList) {
      comments.assignAll(commentList);
    });
  }

  Future<void> addComment({
    required String postId,
    required String content,
    required String postOwnerId,
  }) async {
    final user = _authService.currentUserModel;
    if (user == null) return;

    await _socialService.addComment(
      postId: postId,
      userId: user.uid,
      userName: user.displayName,
      userPhotoURL: user.photoURL,
      content: content,
      postOwnerId: postOwnerId,
    );
  }

  // ==================== FOLLOWS ====================

  Future<void> toggleFollow(String targetUserId) async {
    final user = _authService.currentUserModel;
    if (user == null) return;

    await _socialService.toggleFollow(
      currentUserId: user.uid,
      targetUserId: targetUserId,
    );
    isFollowing.value = !isFollowing.value;
  }

  Future<void> checkFollowing(String targetUserId) async {
    final user = _authService.currentUserModel;
    if (user == null) return;

    isFollowing.value = await _socialService.isFollowing(user.uid, targetUserId);
  }

  void startListeningToFollowers(String userId) {
    _socialService.streamFollowersCount(userId).listen((count) {
      followersCount.value = count;
    });
  }

  void startListeningToFollowing(String userId) {
    _socialService.streamFollowingCount(userId).listen((count) {
      followingCount.value = count;
    });
  }

  // ==================== NOTIFICATIONS ====================

  void startListeningToNotifications() {
    final user = _authService.currentUserModel;
    if (user == null) return;

    _socialService.streamNotifications(user.uid).listen((notifList) {
      notifications.assignAll(notifList);
    });

    _socialService.streamUnreadNotificationCount(user.uid).listen((count) {
      unreadNotifications.value = count;
    });
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    await _socialService.markNotificationAsRead(notificationId);
  }

  void clearError() {
    errorMessage.value = null;
  }
}