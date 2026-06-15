import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../config/app_config.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import 'firebase_service.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseService().firestore;
  final FirebaseStorage _storage = FirebaseService().storage;
  final Uuid _uuid = const Uuid();

  // Get or create individual chat
  Future<String> getOrCreateIndividualChat({
    required String currentUserId,
    required String otherUserId,
  }) async {
    // Check if chat already exists
    final existingChat = await _findExistingIndividualChat(
      currentUserId,
      otherUserId,
    );
    
    if (existingChat != null) {
      return existingChat.chatId;
    }

    // Create new chat
    final chatId = _uuid.v4();
    final chat = ChatModel(
      chatId: chatId,
      chatType: ChatType.individual,
      participants: [currentUserId, otherUserId],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _firestore
        .collection(AppConfig.chatsCollection)
        .doc(chatId)
        .set(chat.toMap());

    return chatId;
  }

  // Find existing individual chat
  Future<ChatModel?> _findExistingIndividualChat(
    String userId1,
    String userId2,
  ) async {
    final querySnapshot = await _firestore
        .collection(AppConfig.chatsCollection)
        .where('chatType', isEqualTo: ChatType.individual.name)
        .where('participants', arrayContains: userId1)
        .get();

    for (var doc in querySnapshot.docs) {
      final chat = ChatModel.fromMap(doc.data());
      if (chat.participants.contains(userId2)) {
        return chat;
      }
    }
    return null;
  }

  // Create group chat
  Future<String> createGroupChat({
    required String currentUserId,
    required String groupName,
    String? groupImage,
    String? groupDescription,
    required List<String> participants,
  }) async {
    final chatId = _uuid.v4();
    final allParticipants = [currentUserId, ...participants];

    String? imageUrl;
    if (groupImage != null) {
      imageUrl = await uploadGroupImage(chatId, File(groupImage));
    }

    final chat = ChatModel(
      chatId: chatId,
      chatType: ChatType.group,
      groupName: groupName,
      groupImage: imageUrl,
      groupDescription: groupDescription,
      participants: allParticipants,
      createdBy: currentUserId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _firestore
        .collection(AppConfig.chatsCollection)
        .doc(chatId)
        .set(chat.toMap());

    return chatId;
  }

  // Stream user chats
  Stream<List<ChatModel>> streamUserChats(String userId) {
    return _firestore
        .collection(AppConfig.chatsCollection)
        .where('participants', arrayContains: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ChatModel.fromMap(doc.data())).toList());
  }

  // Stream single chat
  Stream<ChatModel> streamChat(String chatId) {
    return _firestore
        .collection(AppConfig.chatsCollection)
        .doc(chatId)
        .snapshots()
        .map((doc) => ChatModel.fromMap(doc.data()!));
  }

  // Send text message
  Future<MessageModel> sendTextMessage({
    required String chatId,
    required String senderId,
    required String senderName,
    required String content,
    String? replyToMessageId,
    String? replyToContent,
    String? replyToSenderName,
  }) async {
    final messageId = _uuid.v4();
    final message = MessageModel(
      messageId: messageId,
      chatId: chatId,
      senderId: senderId,
      senderName: senderName,
      content: content,
      type: MessageType.text,
      status: MessageStatus.sent,
      timestamp: DateTime.now(),
      replyToMessageId: replyToMessageId,
      replyToContent: replyToContent,
      replyToSenderName: replyToSenderName,
    );

    await _firestore
        .collection(AppConfig.chatsCollection)
        .doc(chatId)
        .collection(AppConfig.messagesCollection)
        .doc(messageId)
        .set(message.toMap());

    // Update last message in chat
    await _updateChatLastMessage(chatId, message);

    return message;
  }

  // Send image message
  Future<MessageModel> sendImageMessage({
    required String chatId,
    required String senderId,
    required String senderName,
    required File imageFile,
    String? caption,
    String? replyToMessageId,
    String? replyToContent,
    String? replyToSenderName,
  }) async {
    final imageUrl = await uploadChatImage(chatId, imageFile);
    final messageId = _uuid.v4();

    final message = MessageModel(
      messageId: messageId,
      chatId: chatId,
      senderId: senderId,
      senderName: senderName,
      content: caption ?? '📷 Photo',
      type: MessageType.image,
      status: MessageStatus.sent,
      timestamp: DateTime.now(),
      imageUrl: imageUrl,
      replyToMessageId: replyToMessageId,
      replyToContent: replyToContent,
      replyToSenderName: replyToSenderName,
    );

    await _firestore
        .collection(AppConfig.chatsCollection)
        .doc(chatId)
        .collection(AppConfig.messagesCollection)
        .doc(messageId)
        .set(message.toMap());

    await _updateChatLastMessage(chatId, message);

    return message;
  }

  // Stream messages for a chat
  Stream<List<MessageModel>> streamMessages(String chatId) {
    return _firestore
        .collection(AppConfig.chatsCollection)
        .doc(chatId)
        .collection(AppConfig.messagesCollection)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => MessageModel.fromMap(doc.data())).toList());
  }

  // Delete message
  Future<void> deleteMessage(String chatId, String messageId) async {
    await _firestore
        .collection(AppConfig.chatsCollection)
        .doc(chatId)
        .collection(AppConfig.messagesCollection)
        .doc(messageId)
        .update({'isDeleted': true});
  }

  // Mark message as read
  Future<void> markMessageAsRead({
    required String chatId,
    required String messageId,
    required String userId,
  }) async {
    await _firestore
        .collection(AppConfig.chatsCollection)
        .doc(chatId)
        .collection(AppConfig.messagesCollection)
        .doc(messageId)
        .update({
      'readBy': FieldValue.arrayUnion([userId]),
    });

    // Update unread count
    await _firestore
        .collection(AppConfig.chatsCollection)
        .doc(chatId)
        .update({
      'unreadCount.$userId': 0,
    });
  }

  // Increment unread count
  Future<void> incrementUnreadCount({
    required String chatId,
    required String userId,
  }) async {
    await _firestore
        .collection(AppConfig.chatsCollection)
        .doc(chatId)
        .update({
      'unreadCount.$userId': FieldValue.increment(1),
    });
  }

  // Update typing status
  Future<void> updateTypingStatus({
    required String chatId,
    required String userId,
    required bool isTyping,
  }) async {
    await _firestore
        .collection(AppConfig.chatsCollection)
        .doc(chatId)
        .update({
      'typingUsers.$userId': isTyping,
    });
  }

  // Add member to group
  Future<void> addGroupMember({
    required String chatId,
    required String userId,
  }) async {
    await _firestore
        .collection(AppConfig.chatsCollection)
        .doc(chatId)
        .update({
      'participants': FieldValue.arrayUnion([userId]),
    });
  }

  // Remove member from group
  Future<void> removeGroupMember({
    required String chatId,
    required String userId,
  }) async {
    await _firestore
        .collection(AppConfig.chatsCollection)
        .doc(chatId)
        .update({
      'participants': FieldValue.arrayRemove([userId]),
    });
  }

  // Update group info
  Future<void> updateGroupInfo({
    required String chatId,
    String? groupName,
    String? groupImage,
    String? groupDescription,
  }) async {
    final updates = <String, dynamic>{};
    if (groupName != null) updates['groupName'] = groupName;
    if (groupImage != null) updates['groupImage'] = groupImage;
    if (groupDescription != null) updates['groupDescription'] = groupDescription;
    updates['updatedAt'] = DateTime.now().millisecondsSinceEpoch;

    await _firestore
        .collection(AppConfig.chatsCollection)
        .doc(chatId)
        .update(updates);
  }

  // Update chat last message
  Future<void> _updateChatLastMessage(String chatId, MessageModel message) async {
    await _firestore
        .collection(AppConfig.chatsCollection)
        .doc(chatId)
        .update({
      'lastMessage': message.content,
      'lastMessageTime': message.timestamp.millisecondsSinceEpoch,
      'lastMessageSenderId': message.senderId,
      'lastMessageType': message.type.name,
      'updatedAt': message.timestamp.millisecondsSinceEpoch,
    });
  }

  // Upload chat image
  Future<String> uploadChatImage(String chatId, File imageFile) async {
    final ref = _storage.ref(
      '${AppConfig.chatImagesPath}/$chatId/${_uuid.v4()}.jpg',
    );
    final uploadTask = await ref.putFile(imageFile);
    return await uploadTask.ref.getDownloadURL();
  }

  // Upload group image
  Future<String> uploadGroupImage(String chatId, File imageFile) async {
    final ref = _storage.ref(
      '${AppConfig.chatImagesPath}/groups/$chatId/${_uuid.v4()}.jpg',
    );
    final uploadTask = await ref.putFile(imageFile);
    return await uploadTask.ref.getDownloadURL();
  }

  // Get unread count for a chat
  Future<int> getUnreadCount(String chatId, String userId) async {
    final chatDoc = await _firestore
        .collection(AppConfig.chatsCollection)
        .doc(chatId)
        .get();
    
    if (!chatDoc.exists) return 0;
    final chat = ChatModel.fromMap(chatDoc.data()!);
    return chat.unreadCount[userId] ?? 0;
  }
}