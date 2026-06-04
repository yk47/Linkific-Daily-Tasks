import 'package:supabase_flutter/supabase_flutter.dart';

class ChatService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Send Message
  Future<void> sendMessage(String message) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    await _supabase.from('messages').insert({
      'sender_id': user.id,
      'message': message,
    });
  }

  /// Fetch Messages
  Future<List<Map<String, dynamic>>> getMessages() async {
    final response = await _supabase
        .from('messages')
        .select()
        .order('created_at');

    return List<Map<String, dynamic>>.from(response);
  }

  /// Update Message
  Future<void> updateMessage({
    required int messageId,
    required String newMessage,
  }) async {
    await _supabase
        .from('messages')
        .update({'message': newMessage})
        .eq('id', messageId);
  }

  /// Delete Message
  Future<void> deleteMessage(int messageId) async {
    await _supabase.from('messages').delete().eq('id', messageId);
  }

  /// Real-time Message Stream
  Stream<List<Map<String, dynamic>>> getMessagesStream() {
    return _supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .order('created_at');
  }

  /// Current User Id
  String? get currentUserId => _supabase.auth.currentUser?.id;
}
