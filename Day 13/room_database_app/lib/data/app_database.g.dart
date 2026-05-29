// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  NotebookDao? _notebookDaoInstance;

  NoteDao? _noteDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `notebooks` (`id` INTEGER NOT NULL, `name` TEXT NOT NULL, `created_at` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `notes` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `notebook_id` INTEGER NOT NULL, `title` TEXT NOT NULL, `content` TEXT NOT NULL, `created_at` INTEGER NOT NULL, `updated_at` INTEGER NOT NULL, FOREIGN KEY (`notebook_id`) REFERENCES `notebooks` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');
        await database.execute(
            'CREATE INDEX `index_notes_notebook_id` ON `notes` (`notebook_id`)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  NotebookDao get notebookDao {
    return _notebookDaoInstance ??= _$NotebookDao(database, changeListener);
  }

  @override
  NoteDao get noteDao {
    return _noteDaoInstance ??= _$NoteDao(database, changeListener);
  }
}

class _$NotebookDao extends NotebookDao {
  _$NotebookDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _notebookEntityInsertionAdapter = InsertionAdapter(
            database,
            'notebooks',
            (NotebookEntity item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'created_at': item.createdAtMillis
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<NotebookEntity> _notebookEntityInsertionAdapter;

  @override
  Future<NotebookEntity?> findNotebookById(int id) async {
    return _queryAdapter.query('SELECT * FROM notebooks WHERE id = ?1 LIMIT 1',
        mapper: (Map<String, Object?> row) => NotebookEntity(
            id: row['id'] as int,
            name: row['name'] as String,
            createdAtMillis: row['created_at'] as int),
        arguments: [id]);
  }

  @override
  Future<void> insertNotebook(NotebookEntity notebook) async {
    await _notebookEntityInsertionAdapter.insert(
        notebook, OnConflictStrategy.replace);
  }
}

class _$NoteDao extends NoteDao {
  _$NoteDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _noteEntityInsertionAdapter = InsertionAdapter(
            database,
            'notes',
            (NoteEntity item) => <String, Object?>{
                  'id': item.id,
                  'notebook_id': item.notebookId,
                  'title': item.title,
                  'content': item.content,
                  'created_at': item.createdAtMillis,
                  'updated_at': item.updatedAtMillis
                },
            changeListener),
        _noteEntityUpdateAdapter = UpdateAdapter(
            database,
            'notes',
            ['id'],
            (NoteEntity item) => <String, Object?>{
                  'id': item.id,
                  'notebook_id': item.notebookId,
                  'title': item.title,
                  'content': item.content,
                  'created_at': item.createdAtMillis,
                  'updated_at': item.updatedAtMillis
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<NoteEntity> _noteEntityInsertionAdapter;

  final UpdateAdapter<NoteEntity> _noteEntityUpdateAdapter;

  @override
  Stream<List<NoteEntity>> watchNotesForNotebook(int notebookId) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM notes WHERE notebook_id = ?1 ORDER BY updated_at DESC, id DESC',
        mapper: (Map<String, Object?> row) => NoteEntity(
            id: row['id'] as int?,
            notebookId: row['notebook_id'] as int,
            title: row['title'] as String,
            content: row['content'] as String,
            createdAtMillis: row['created_at'] as int,
            updatedAtMillis: row['updated_at'] as int),
        arguments: [notebookId],
        queryableName: 'notes',
        isView: false);
  }

  @override
  Future<NoteEntity?> findNoteById(int id) async {
    return _queryAdapter.query('SELECT * FROM notes WHERE id = ?1 LIMIT 1',
        mapper: (Map<String, Object?> row) => NoteEntity(
            id: row['id'] as int?,
            notebookId: row['notebook_id'] as int,
            title: row['title'] as String,
            content: row['content'] as String,
            createdAtMillis: row['created_at'] as int,
            updatedAtMillis: row['updated_at'] as int),
        arguments: [id]);
  }

  @override
  Future<void> deleteNoteById(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM notes WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<int> insertNote(NoteEntity note) {
    return _noteEntityInsertionAdapter.insertAndReturnId(
        note, OnConflictStrategy.replace);
  }

  @override
  Future<int> updateNote(NoteEntity note) {
    return _noteEntityUpdateAdapter.updateAndReturnChangedRows(
        note, OnConflictStrategy.abort);
  }
}
