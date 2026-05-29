import 'dart:async';

import 'note_entity.dart';

abstract class NotesRepository {
  Stream<List<NoteEntity>> watchNotes();

  Future<NoteEntity?> findNoteById(int id);

  Future<void> saveNote({
    NoteEntity? existing,
    required String title,
    required String content,
  });

  Future<void> deleteNote(NoteEntity note);

  Future<void> seed();
}
