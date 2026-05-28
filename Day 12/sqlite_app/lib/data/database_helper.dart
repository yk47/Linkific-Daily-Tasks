import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

import '../models/note.dart';
import '../models/note_category.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  static const String _databaseName = 'sqlite_notes.db';
  static const int _databaseVersion = 1;
  static const String _categoriesTable = 'categories';
  static const String _notesTable = 'notes';

  Future<Database>? _database;

  Future<Database> get database async {
    _database ??= _openDatabase();
    return _database!;
  }

  Future<Database> _openDatabase() async {
    final databasePath = await getDatabasesPath();
    final fullPath = path.join(databasePath, _databaseName);

    return openDatabase(
      fullPath,
      version: _databaseVersion,
      onConfigure: _configureDatabase,
      onCreate: _createDatabase,
    );
  }

  Future<void> _configureDatabase(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_categoriesTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE
      )
    ''');

    await db.execute('''
      CREATE TABLE $_notesTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        category_id INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (category_id) REFERENCES $_categoriesTable (id) ON DELETE RESTRICT
      )
    ''');

    await _seedCategories(db);
  }

  Future<void> _seedCategories(Database db) async {
    final batch = db.batch();

    for (final category in _defaultCategories) {
      batch.insert(
        _categoriesTable,
        category.toInsertMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }

    await batch.commit(noResult: true);
  }

  final List<NoteCategory> _defaultCategories = const <NoteCategory>[
    NoteCategory(name: 'Personal'),
    NoteCategory(name: 'Work'),
    NoteCategory(name: 'Study'),
    NoteCategory(name: 'Ideas'),
  ];

  Future<List<NoteCategory>> getCategories() async {
    final db = await database;
    final rows = await db.query(_categoriesTable, orderBy: 'name ASC');
    return rows.map(NoteCategory.fromMap).toList(growable: false);
  }

  Future<int> insertCategory(NoteCategory category) async {
    final db = await database;
    return db.insert(
      _categoriesTable,
      category.toInsertMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<int> insertNote(Note note) async {
    final db = await database;
    return db.insert(_notesTable, note.toInsertMap());
  }

  Future<List<Note>> getNotes({
    String? searchQuery,
    int? categoryId,
    int limit = 100,
    int offset = 0,
  }) async {
    final db = await database;
    final whereClauses = <String>[];
    final whereArgs = <Object?>[];

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      whereClauses.add('(n.title LIKE ? OR n.content LIKE ?)');
      whereArgs.addAll(<String>['%$searchQuery%', '%$searchQuery%']);
    }

    if (categoryId != null) {
      whereClauses.add('n.category_id = ?');
      whereArgs.add(categoryId);
    }

    final whereSql = whereClauses.isEmpty
        ? ''
        : 'WHERE ${whereClauses.join(' AND ')}';

    final rows = await db.rawQuery(
      '''
      SELECT
        n.id,
        n.title,
        n.content,
        n.category_id,
        n.created_at,
        n.updated_at,
        c.name AS category_name
      FROM $_notesTable n
      LEFT JOIN $_categoriesTable c ON c.id = n.category_id
      $whereSql
      ORDER BY n.updated_at DESC, n.id DESC
      LIMIT ? OFFSET ?
    ''',
      <Object?>[...whereArgs, limit, offset],
    );

    return rows.map(Note.fromMap).toList(growable: false);
  }

  Future<Note?> getNoteById(int id) async {
    final db = await database;
    final rows = await db.rawQuery(
      '''
      SELECT
        n.id,
        n.title,
        n.content,
        n.category_id,
        n.created_at,
        n.updated_at,
        c.name AS category_name
      FROM $_notesTable n
      LEFT JOIN $_categoriesTable c ON c.id = n.category_id
      WHERE n.id = ?
      LIMIT 1
    ''',
      <Object?>[id],
    );

    if (rows.isEmpty) {
      return null;
    }

    return Note.fromMap(rows.first);
  }

  Future<int> updateNote(Note note) async {
    final db = await database;
    return db.update(
      _notesTable,
      note.toUpdateMap(),
      where: 'id = ?',
      whereArgs: <Object?>[note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return db.delete(_notesTable, where: 'id = ?', whereArgs: <Object?>[id]);
  }
}
