import 'dart:async';

import 'app_database.dart';
import 'note_entity.dart';
import 'notes_repository.dart';
import 'notebook_entity.dart';

class FloorNotesRepository implements NotesRepository {
  static const int _defaultNotebookId = 1;
  static const String _defaultNotebookName = 'Daily Notes';

  final AppDatabase _database;

  FloorNotesRepository(this._database);

  @override
  Stream<List<NoteEntity>> watchNotes() {
    return _database.noteDao.watchNotesForNotebook(_defaultNotebookId);
  }

  @override
  Future<NoteEntity?> findNoteById(int id) {
    return _database.noteDao.findNoteById(id);
  }

  @override
  Future<void> saveNote({
    NoteEntity? existing,
    required String title,
    required String content,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final note = NoteEntity(
      id: existing?.id,
      notebookId: _defaultNotebookId,
      title: title.trim(),
      content: content.trim(),
      createdAtMillis: existing?.createdAtMillis ?? now,
      updatedAtMillis: now,
    );

    if (existing == null) {
      await _database.noteDao.insertNote(note);
      return;
    }

    await _database.noteDao.updateNote(note);
  }

  @override
  Future<void> deleteNote(NoteEntity note) async {
    final id = note.id;
    if (id != null) {
      await _database.noteDao.deleteNoteById(id);
    }
  }

  @override
  Future<void> seed() async {
    final notebook = await _database.notebookDao.findNotebookById(
      _defaultNotebookId,
    );
    if (notebook == null) {
      await _database.notebookDao.insertNotebook(
        NotebookEntity(
          id: _defaultNotebookId,
          name: _defaultNotebookName,
          createdAtMillis: DateTime.now().millisecondsSinceEpoch,
        ),
      );
    }
  }
}
