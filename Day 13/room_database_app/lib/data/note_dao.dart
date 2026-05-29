import 'package:floor/floor.dart';

import 'note_entity.dart';

@dao
abstract class NoteDao {
  @Query(
    'SELECT * FROM notes WHERE notebook_id = :notebookId ORDER BY updated_at DESC, id DESC',
  )
  Stream<List<NoteEntity>> watchNotesForNotebook(int notebookId);

  @Query('SELECT * FROM notes WHERE id = :id LIMIT 1')
  Future<NoteEntity?> findNoteById(int id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertNote(NoteEntity note);

  @Update()
  Future<int> updateNote(NoteEntity note);

  @Query('DELETE FROM notes WHERE id = :id')
  Future<void> deleteNoteById(int id);
}
