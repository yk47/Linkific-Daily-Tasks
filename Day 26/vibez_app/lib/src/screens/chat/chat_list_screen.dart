import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme.dart';
import '../../models/chat_model.dart';
import '../../models/user_model.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/chat_controller.dart';
import '../../services/auth_service.dart';
import '../../widgets/common_widgets.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final _searchController = TextEditingController();
  final _authService = AuthService();
  List<UserModel> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ChatController>().startListeningToChats();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }

    setState(() => _isSearching = true);
    _authService.searchUsers(query).listen((users) {
      if (mounted) {
        setState(() => _searchResults = users);
      }
    });
  }

  Future<void> _startChat(UserModel otherUser) async {
    try {
      final chatController = Get.find<ChatController>();
      final chatId = await chatController.getOrCreateChat(otherUser.uid);

      if (mounted) {
        Get.toNamed(
          '/chat',
          arguments: {
            'chatId': chatId,
            'user': otherUser,
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to start chat')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline_rounded),
            onPressed: () {
              Get.toNamed('/profile');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () async {
              await Get.find<AuthController>().logout();
              if (mounted) {
                Get.offNamed('/login');
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          SearchBarWidget(
            controller: _searchController,
            onChanged: _onSearchChanged,
            onClear: () {
              setState(() {
                _isSearching = false;
                _searchResults = [];
              });
            },
          ),

          // Content
          Expanded(
            child: _isSearching ? _buildSearchResults() : _buildChatList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/users');
        },
        child: const Icon(Icons.edit_rounded),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return const EmptyState(
        icon: Icons.search_off_rounded,
        title: 'No users found',
        subtitle: 'Try a different search term',
      );
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final user = _searchResults[index];
        final currentUser = Get.find<AuthController>().user.value;

        if (user.uid == currentUser?.uid) return const SizedBox.shrink();

        return _buildUserTile(user);
      },
    );
  }

  Widget _buildChatList() {
    return Obx(() {
      final chatController = Get.find<ChatController>();
      final chats = chatController.chats;

      if (chats.isEmpty) {
        return const EmptyState(
          icon: Icons.chat_bubble_outline_rounded,
          title: 'No chats yet',
          subtitle: 'Start a conversation with someone',
          actionLabel: 'New Chat',
        );
      }

      return ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return _buildChatTile(chat);
        },
      );
    });
  }

  Widget _buildUserTile(UserModel user) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: UserAvatar(
          photoURL: user.photoURL,
          displayName: user.displayName,
          radius: 24,
          isOnline: user.isOnline,
          showOnlineIndicator: true,
        ),
        title: Text(
          user.displayName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: user.bio != null ? Text(user.bio!) : null,
        onTap: () => _startChat(user),
      ),
    );
  }

  Widget _buildChatTile(ChatModel chat) {
    String name;
    String? subtitle;
    String? photoURL;
    bool isOnline = false;

    if (chat.chatType == ChatType.individual) {
      name = chat.participants.firstWhere(
        (id) => id != Get.find<AuthController>().user.value?.uid,
      );
      subtitle = chat.lastMessage;
    } else {
      name = chat.groupName ?? 'Group Chat';
      subtitle = chat.lastMessage != null
          ? '${chat.lastMessageSenderId}: ${chat.lastMessage}'
          : null;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Stack(
          children: [
            UserAvatar(
              photoURL: photoURL,
              displayName: name,
              radius: 28,
            ),
            if (chat.chatType == ChatType.group)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.group_rounded,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.w600),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppTheme.textSecondary),
              )
            : null,
        trailing: chat.lastMessageTime != null
            ? Text(
                _formatTime(chat.lastMessageTime!),
                style: const TextStyle(
                  color: AppTheme.textHint,
                  fontSize: 12,
                ),
              )
            : null,
        onTap: () {
          Get.toNamed(
            '/chat',
            arguments: {'chatId': chat.chatId},
          );
        },
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d';
    } else {
      return '${time.day}/${time.month}';
    }
  }
}

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const SearchBarWidget({
    super.key,
    required this.controller,
    this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search users...',
          prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.textHint),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded),
                  onPressed: () {
                    controller.clear();
                    onClear?.call();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}