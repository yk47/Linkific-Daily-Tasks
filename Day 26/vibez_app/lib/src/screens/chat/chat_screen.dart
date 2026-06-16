import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../config/theme.dart';
import '../../models/user_model.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/chat_controller.dart';
import '../../services/auth_service.dart';
import '../../models/chat_model.dart';
import '../../widgets/common_widgets.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final UserModel? user;

  const ChatScreen({
    super.key,
    required this.chatId,
    this.user,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final _imagePicker = ImagePicker();
  final _authService = AuthService();
  UserModel? _otherUser;
  String? _replyToMessageId;
  String? _replyToContent;
  String? _replyToSenderName;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ChatController>().startListeningToMessages(widget.chatId);
    });
    _loadOtherUser();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    Get.find<ChatController>().disposeChat();
    super.dispose();
  }

  void _loadOtherUser() {
    if (widget.user != null) {
      setState(() => _otherUser = widget.user);
      return;
    }

    final chatController = Get.find<ChatController>();
    final currentUser = Get.find<AuthController>().user.value;
    final chat = chatController.currentChat.value;

    if (chat != null && currentUser != null) {
      final otherUserId = chat.participants.firstWhere(
        (id) => id != currentUser.uid,
      );
      _authService.getUserById(otherUserId).then((user) {
        if (mounted) {
          setState(() => _otherUser = user);
        }
      });
    }
  }

  Future<void> _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    final chatController = Get.find<ChatController>();
    await chatController.sendTextMessage(
      chatId: widget.chatId,
      content: content,
      replyToMessageId: _replyToMessageId,
      replyToContent: _replyToContent,
      replyToSenderName: _replyToSenderName,
    );

    _messageController.clear();
    _clearReply();
    _scrollToBottom();
  }

  Future<void> _pickAndSendImage() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      final chatController = Get.find<ChatController>();
      await chatController.sendImageMessage(
        chatId: widget.chatId,
        imageFile: File(pickedFile.path),
        replyToMessageId: _replyToMessageId,
        replyToContent: _replyToContent,
        replyToSenderName: _replyToSenderName,
      );
      _clearReply();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _clearReply() {
    setState(() {
      _replyToMessageId = null;
      _replyToContent = null;
      _replyToSenderName = null;
    });
  }

  String? get _chatTitle {
    if (_otherUser != null) return _otherUser!.displayName;
    final chat = Get.find<ChatController>().currentChat.value;
    if (chat?.chatType == ChatType.group) return chat?.groupName;
    return 'Chat';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            UserAvatar(
              photoURL: _otherUser?.photoURL,
              displayName: _otherUser?.displayName,
              radius: 18,
              isOnline: _otherUser?.isOnline ?? false,
              showOnlineIndicator: true,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _chatTitle ?? 'Chat',
                  style: const TextStyle(fontSize: 16),
                ),
                if (_otherUser != null)
                  Text(
                    _otherUser!.isOnline ? 'Online' : 'Offline',
                    style: TextStyle(
                      fontSize: 12,
                      color: _otherUser!.isOnline
                          ? AppTheme.onlineGreen
                          : AppTheme.textHint,
                    ),
                  ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: _showChatOptions,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_replyToMessageId != null) _buildReplyPreview(),
          Expanded(child: _buildMessagesList()),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildReplyPreview() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.05),
        border: Border(
          left: BorderSide(
            color: AppTheme.primaryColor.withValues(alpha: 0.5),
            width: 4,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Replying to ${_replyToSenderName ?? "someone"}',
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _replyToContent ?? '',
                  style: const TextStyle(fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 20),
            onPressed: _clearReply,
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return Obx(() {
      final chatProvider = Get.find<ChatController>();
      final messages = chatProvider.messages;

      if (messages.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chat_bubble_outline_rounded,
                size: 48,
                color: AppTheme.textHint,
              ),
              SizedBox(height: 16),
              Text(
                'No messages yet',
                style: TextStyle(color: AppTheme.textHint, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Say hello to start the conversation!',
                style: TextStyle(color: AppTheme.textHint, fontSize: 14),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(8),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          final currentUser = Get.find<AuthController>().user.value;
          final isMe = message.senderId == currentUser?.uid;

          if (message.isDeleted) {
            return const Padding(
              padding: EdgeInsets.all(8),
              child: Center(
                child: Text(
                  'This message was deleted',
                  style: TextStyle(
                    color: AppTheme.textHint,
                    fontStyle: FontStyle.italic,
                    fontSize: 12,
                  ),
                ),
              ),
            );
          }

          return GestureDetector(
            onLongPress: () => _showMessageOptions(message),
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (message.replyToMessageId != null)
                  Padding(
                    padding: EdgeInsets.only(
                      left: isMe ? 0 : 48,
                      right: isMe ? 48 : 0,
                      top: 4,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.dividerColor),
                      ),
                      child: Text(
                        'Replying to ${message.replyToSenderName ?? "someone"}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.textHint,
                        ),
                      ),
                    ),
                  ),
                MessageBubble(
                  message: message.content,
                  isMe: isMe,
                  time: message.formattedTime,
                  imageUrl: message.imageUrl,
                ),
                if (isMe)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Text(
                      message.statusIcon,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
              ],
            ),
          );
        },
      );
    });
  }

  Widget _buildMessageInput() {
    return Container(
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
            Container(
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.image_rounded,
                  color: AppTheme.primaryColor,
                ),
                onPressed: _pickAndSendImage,
              ),
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
                  controller: _messageController,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: const BoxDecoration(
                color: AppTheme.primaryColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send_rounded, color: Colors.white),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMessageOptions(dynamic message) {
    final currentUser = Get.find<AuthController>().user.value;
    final isMe = message.senderId == currentUser?.uid;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 8),
              if (message.type.toString() != 'image') ...[
                ListTile(
                  leading: const Icon(Icons.reply_rounded),
                  title: const Text('Reply'),
                  onTap: () {
                    setState(() {
                      _replyToMessageId = message.messageId;
                      _replyToContent = message.content;
                      _replyToSenderName = message.senderName;
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
              if (isMe) ...[
                ListTile(
                  leading: const Icon(Icons.delete_outline_rounded),
                  title: const Text('Delete Message'),
                  onTap: () {
                    Get.find<ChatController>().deleteMessage(
                      widget.chatId,
                      message.messageId,
                    );
                    Navigator.pop(context);
                  },
                ),
              ],
              if (message.type.toString() == 'image')
                ListTile(
                  leading: const Icon(Icons.download_rounded),
                  title: const Text('Save Image'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _showChatOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.person_rounded),
                title: const Text('View Profile'),
                onTap: () {
                  Navigator.pop(context);
                  if (_otherUser != null) {
                    Get.toNamed(
                      '/user-profile',
                      arguments: _otherUser,
                    );
                  }
                },
              ),
              if (_otherUser != null)
                ListTile(
                  leading: const Icon(Icons.phone_rounded),
                  title: const Text('Call'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ListTile(
                leading: const Icon(Icons.search_rounded),
                title: const Text('Search in Chat'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}