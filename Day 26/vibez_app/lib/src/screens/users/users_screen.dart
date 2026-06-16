import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme.dart';
import '../../models/user_model.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/chat_controller.dart';
import '../../services/auth_service.dart';
import '../../widgets/common_widgets.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final _searchController = TextEditingController();
  final _authService = AuthService();
  List<UserModel> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadUsers({String? query}) {
    setState(() => _isLoading = true);

    if (query != null && query.isNotEmpty) {
      _authService.searchUsers(query).listen((users) {
        if (mounted) {
          setState(() {
            _users = users;
            _isLoading = false;
          });
        }
      });
    } else {
      _authService.searchUsers('').listen((users) {
        if (mounted) {
          setState(() {
            _users = users;
            _isLoading = false;
          });
        }
      });
    }
  }

  Future<void> _startChat(UserModel otherUser) async {
    final currentUser = Get.find<AuthController>().user.value;
    if (currentUser?.uid == otherUser.uid) return;

    try {
      final chatProvider = Get.find<ChatController>();
      final chatId = await chatProvider.getOrCreateChat(otherUser.uid);

      if (mounted) {
        Get.offNamed(
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
    final currentUser = Get.find<AuthController>().user.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Chat'),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.dividerColor),
            ),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search users...',
                prefixIcon:
                    Icon(Icons.search_rounded, color: AppTheme.textHint),
                suffixIcon: Icon(Icons.clear_rounded, color: AppTheme.textHint),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (query) => _loadUsers(query: query),
            ),
          ),

          Expanded(
            child: _isLoading
                ? const LoadingIndicator(message: 'Loading users...')
                : _users.isEmpty
                    ? const EmptyState(
                        icon: Icons.people_outline_rounded,
                        title: 'No users found',
                        subtitle: 'Try a different search term',
                      )
                    : ListView.builder(
                        itemCount: _users.length,
                        itemBuilder: (context, index) {
                          final user = _users[index];
                          final isCurrentUser =
                              user.uid == currentUser?.uid;

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
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
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: user.bio != null
                                  ? Text(
                                      user.bio!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : const Text('No bio'),
                              trailing: isCurrentUser
                                  ? const Chip(
                                      label: Text(
                                        'You',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    )
                                  : const Icon(
                                      Icons.chat_bubble_outline_rounded,
                                      color: AppTheme.primaryColor,
                                    ),
                              onTap: isCurrentUser
                                  ? null
                                  : () => _startChat(user),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}