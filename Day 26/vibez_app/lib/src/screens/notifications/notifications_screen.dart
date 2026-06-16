import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../config/theme.dart';
import '../../controllers/social_controller.dart';
import '../../widgets/common_widgets.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<SocialController>().startListeningToNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: Obx(() {
        final social = Get.find<SocialController>();
        final notifications = social.notifications;

        if (notifications.isEmpty) {
          return const EmptyState(
            icon: Icons.notifications_none_rounded,
            title: 'No notifications yet',
            subtitle: 'When someone likes or comments on your post,\nyou\'ll see it here.',
          );
        }

        return ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            final isUnread = !notification.read;

            return Dismissible(
              key: Key(notification.notificationId),
              direction: DismissDirection.horizontal,
              background: Container(
                color: AppTheme.primaryColor,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20),
                child: const Icon(Icons.check_rounded, color: Colors.white),
              ),
              onDismissed: (_) {
                social.markNotificationAsRead(notification.notificationId);
              },
              child: ListTile(
                leading: UserAvatar(
                  photoURL: notification.fromUserPhotoURL,
                  displayName: notification.fromUserName,
                  radius: 22,
                  showOnlineIndicator: isUnread,
                ),
                title: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
                    children: [
                      TextSpan(
                        text: notification.fromUserName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(
                        text: ' ${notification.displayText}',
                      ),
                    ],
                  ),
                ),
                subtitle: Text(
                  timeago.format(notification.timestamp),
                  style: const TextStyle(color: AppTheme.textHint, fontSize: 12),
                ),
                trailing: isUnread
                    ? Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppTheme.primaryColor,
                          shape: BoxShape.circle,
                        ),
                      )
                    : null,
                onTap: () {
                  social.markNotificationAsRead(notification.notificationId);
                  if (notification.postId != null) {
                    // Navigate to post
                  } else if (notification.type.toString() == 'follow') {
                    // Navigate to user profile
                  }
                },
              ),
            );
          },
        );
      }),
    );
  }
}