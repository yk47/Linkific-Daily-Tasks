import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../config/theme.dart';
import '../../models/post_model.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/social_controller.dart';
import '../../widgets/common_widgets.dart';

class PostDetailScreen extends StatefulWidget {
  final PostModel post;

  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<SocialController>().startListeningToComments(widget.post.postId);
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _addComment() {
    final content = _commentController.text.trim();
    if (content.isEmpty) return;

    Get.find<SocialController>().addComment(
      postId: widget.post.postId,
      content: content,
      postOwnerId: widget.post.userId,
    );
    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Get.find<AuthController>().user.value;
    final isLiked = currentUser != null && widget.post.likes.contains(currentUser.uid);

    return Scaffold(
      appBar: AppBar(title: const Text('Post')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        UserAvatar(
                          photoURL: widget.post.userPhotoURL,
                          displayName: widget.post.userName,
                          radius: 20,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.post.userName,
                                style: const TextStyle(fontWeight: FontWeight.w600)),
                            Text(timeago.format(widget.post.timestamp),
                                style: const TextStyle(color: AppTheme.textHint, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  if (widget.post.imageUrl != null)
                    Image.network(
                      widget.post.imageUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, _, _) =>
                          Container(height: 200, color: AppTheme.dividerColor),
                    ),

                  if (widget.post.caption != null)
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(widget.post.caption!, style: const TextStyle(fontSize: 15)),
                    ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            isLiked ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                            color: isLiked ? AppTheme.primaryColor : null,
                          ),
                          onPressed: () {
                            Get.find<SocialController>().toggleLike(
                              widget.post.postId,
                              widget.post.userId,
                            );
                          },
                        ),
                        Text('${widget.post.likeCount} likes'),
                        const Spacer(),
                        Text('${widget.post.commentCount} comments',
                            style: const TextStyle(color: AppTheme.textHint)),
                      ],
                    ),
                  ),

                  const Divider(),

                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Text('Comments',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  ),

                  Obx(() {
                    final social = Get.find<SocialController>();
                    final comments = social.comments;

                    if (comments.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(32),
                        child: Center(
                          child: Text('No comments yet. Be the first!',
                              style: TextStyle(color: AppTheme.textHint)),
                        ),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              UserAvatar(
                                photoURL: comment.userPhotoURL,
                                displayName: comment.userName,
                                radius: 16,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(comment.userName,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600, fontSize: 13)),
                                        const SizedBox(width: 8),
                                        Text(timeago.format(comment.timestamp),
                                            style: const TextStyle(
                                                color: AppTheme.textHint, fontSize: 11)),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(comment.content, style: const TextStyle(fontSize: 14)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  UserAvatar(
                    photoURL: currentUser?.photoURL,
                    displayName: currentUser?.displayName,
                    radius: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundColor,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppTheme.dividerColor),
                      ),
                      child: TextField(
                        controller: _commentController,
                        decoration: const InputDecoration(
                          hintText: 'Add a comment...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        onSubmitted: (_) => _addComment(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send_rounded, color: AppTheme.primaryColor),
                    onPressed: _addComment,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}