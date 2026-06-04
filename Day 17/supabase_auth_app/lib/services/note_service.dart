import 'package:supabase_flutter/supabase_flutter.dart';

class NoteService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> createNote(String title) async {
    final user = _supabase.auth.currentUser;

    await _supabase.from('notes').insert({'title': title, 'user_id': user!.id});
  }

  Future<void> updateNote(int id, String title) async {
    await _supabase.from('notes').update({'title': title}).eq('id', id);
  }

  Future<void> deleteNote(int id) async {
    await _supabase.from('notes').delete().eq('id', id);
  }

  Stream<List<Map<String, dynamic>>> getNotes() {
    return _supabase
        .from('notes')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) {
          print("Notes Loaded: ${data.length}");
          return List<Map<String, dynamic>>.from(data);
        });
  }
}
