import 'dart:io';
import 'package:get/get.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';
import '../services/chat_service.dart';
import '../services/auth_service.dart';

class ChatController extends GetxController {
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  final RxList<ChatModel> chats = RxList<ChatModel>();
  final RxList<MessageModel> messages = RxList<MessageModel>();
  final Rx<ChatModel?> currentChat = Rx<ChatModel?>(null);
  final Rx<UserModel?> chatPartner = Rx<UserModel?>(null);
  final RxBool isLoading = RxBool(false);
  final Rx<String?> errorMessage = Rx<String?>(null);
  final RxSet<String> typingUsers = RxSet<String>();

  // Stream chats for current user
  void startListeningToChats() {
    final currentUser = _authService.currentUserModel;
    if (currentUser == null) return;

    _chatService.streamUserChats(currentUser.uid).listen((chatList) {
      chats.assignAll(chatList);
    });
  }

  // Stream messages for a specific chat
  void startListeningToMessages(String chatId) {
    _chatService.streamMessages(chatId).listen((msgList) {
      messages.assignAll(msgList);
    });

    // Listen for typing status
    _chatService.streamChat(chatId).listen((chat) {
      currentChat.value = chat;
      if (chat.chatType == ChatType.individual) {
        _updateChatPartner(chat);
      }
      _updateTypingUsers(chat);
    });
  }

  void _updateChatPartner(ChatModel chat) {
    final currentUser = _authService.currentUserModel;
    if (currentUser == null) return;

    final partnerId = chat.participants.firstWhere(
      (id) => id != currentUser.uid,
    );

    _authService.getUserById(partnerId).then((user) {
      chatPartner.value = user;
    });
  }

  void _updateTypingUsers(ChatModel chat) {
    typingUsers.clear();
    final currentUser = _authService.currentUserModel;
    if (currentUser == null) return;
  }

  // Send text message
  Future<void> sendTextMessage({
    required String chatId,
    required String content,
    String? replyToMessageId,
    String? replyToContent,
    String? replyToSenderName,
  }) async {
    final currentUser = _authService.currentUserModel;
    if (currentUser == null) return;

    try {
      await _chatService.sendTextMessage(
        chatId: chatId,
        senderId: currentUser.uid,
        senderName: currentUser.displayName,
        content: content,
        replyToMessageId: replyToMessageId,
        replyToContent: replyToContent,
        replyToSenderName: replyToSenderName,
      );
    } catch (e) {
      errorMessage.value = 'Failed to send message';
    }
  }

  // Send image message
  Future<void> sendImageMessage({
    required String chatId,
    required File imageFile,
    String? caption,
    String? replyToMessageId,
    String? replyToContent,
    String? replyToSenderName,
  }) async {
    final currentUser = _authService.currentUserModel;
    if (currentUser == null) return;

    try {
      await _chatService.sendImageMessage(
        chatId: chatId,
        senderId: currentUser.uid,
        senderName: currentUser.displayName,
        imageFile: imageFile,
        caption: caption,
        replyToMessageId: replyToMessageId,
        replyToContent: replyToContent,
        replyToSenderName: replyToSenderName,
      );
    } catch (e) {
      errorMessage.value = 'Failed to send image';
    }
  }

  // Get or create chat
  Future<String> getOrCreateChat(String otherUserId) async {
    final currentUser = _authService.currentUserModel;
    if (currentUser == null) throw Exception('User not authenticated');

    return await _chatService.getOrCreateIndividualChat(
      currentUserId: currentUser.uid,
      otherUserId: otherUserId,
    );
  }

  // Create group chat
  Future<String> createGroupChat({
    required String groupName,
    String? groupImage,
    String? groupDescription,
    required List<String> participants,
  }) async {
    final currentUser = _authService.currentUserModel;
    if (currentUser == null) throw Exception('User not authenticated');

    return await _chatService.createGroupChat(
      currentUserId: currentUser.uid,
      groupName: groupName,
      groupImage: groupImage,
      groupDescription: groupDescription,
      participants: participants,
    );
  }

  // Update typing status
  Future<void> updateTypingStatus(String chatId, bool isTyping) async {
    final currentUser = _authService.currentUserModel;
    if (currentUser == null) return;

    await _chatService.updateTypingStatus(
      chatId: chatId,
      userId: currentUser.uid,
      isTyping: isTyping,
    );
  }

  // Mark message as read
  Future<void> markAsRead(String chatId, String messageId) async {
    final currentUser = _authService.currentUserModel;
    if (currentUser == null) return;

    await _chatService.markMessageAsRead(
      chatId: chatId,
      messageId: messageId,
      userId: currentUser.uid,
    );
  }

  // Delete message
  Future<void> deleteMessage(String chatId, String messageId) async {
    await _chatService.deleteMessage(chatId, messageId);
  }

  // Add group member
  Future<void> addGroupMember(String chatId, String userId) async {
    await _chatService.addGroupMember(chatId: chatId, userId: userId);
  }

  // Remove group member
  Future<void> removeGroupMember(String chatId, String userId) async {
    await _chatService.removeGroupMember(chatId: chatId, userId: userId);
  }

  // Update group info
  Future<void> updateGroupInfo({
    required String chatId,
    String? groupName,
    String? groupImage,
    String? groupDescription,
  }) async {
    await _chatService.updateGroupInfo(
      chatId: chatId,
      groupName: groupName,
      groupImage: groupImage,
      groupDescription: groupDescription,
    );
  }

  // Stop listening (cleanup)
  void disposeChat() {
    messages.clear();
    currentChat.value = null;
    chatPartner.value = null;
    typingUsers.clear();
  }

  void clearError() {
    errorMessage.value = null;
  }
}