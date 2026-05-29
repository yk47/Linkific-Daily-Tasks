import 'package:floor/floor.dart';

import 'notebook_entity.dart';

@dao
abstract class NotebookDao {
  @Query('SELECT * FROM notebooks WHERE id = :id LIMIT 1')
  Future<NotebookEntity?> findNotebookById(int id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertNotebook(NotebookEntity notebook);
}
