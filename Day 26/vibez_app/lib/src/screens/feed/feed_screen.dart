import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../config/theme.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/social_controller.dart';
import '../../widgets/common_widgets.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<SocialController>().startListeningToFeed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.videocam_rounded, color: AppTheme.primaryColor),
            const SizedBox(width: 8),
            Text(
              'Vibez',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w800,
                fontSize: 22,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person_outline_rounded),
            onPressed: () {
              Get.toNamed('/profile');
            },
          ),
        ],
      ),
      body: Obx(() {
        final social = Get.find<SocialController>();
        final posts = social.feedPosts;

        if (posts.isEmpty) {
          return const EmptyState(
            icon: Icons.explore_rounded,
            title: 'Welcome to Vibez!',
            subtitle: 'Create your first post and share your vibez with the world.',
            actionLabel: 'Create Post',
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            social.startListeningToFeed();
          },
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 8),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              final currentUser = Get.find<AuthController>().user.value;
              final isLiked = currentUser != null && post.likes.contains(currentUser.uid);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User header
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          UserAvatar(
                            photoURL: post.userPhotoURL,
                            displayName: post.userName,
                            radius: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post.userName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  timeago.format(post.timestamp),
                                  style: const TextStyle(
                                    color: AppTheme.textHint,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_horiz_rounded),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),

                    // Post image
                    if (post.imageUrl != null)
                      GestureDetector(
                        onTap: () => _openPostDetail(post),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.network(
                            post.imageUrl!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(color: AppTheme.dividerColor),
                          ),
                        ),
                      ),

                    // Caption
                    if (post.caption != null && post.caption!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                        child: Text(
                          post.caption!,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),

                    // Action buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              isLiked ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                              color: isLiked ? AppTheme.primaryColor : null,
                            ),
                            onPressed: () {
                              social.toggleLike(post.postId, post.userId);
                            },
                          ),
                          Text(
                            '${post.likeCount}',
                            style: const TextStyle(fontSize: 13),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.chat_bubble_outline_rounded),
                            onPressed: () => _openPostDetail(post),
                          ),
                          Text(
                            '${post.commentCount}',
                            style: const TextStyle(fontSize: 13),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.share_outlined),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }

  void _openPostDetail(dynamic post) {
    Get.toNamed('/post-detail', arguments: post);
  }
}