import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'note_dao.dart';
import 'note_entity.dart';
import 'notebook_dao.dart';
import 'notebook_entity.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [NotebookEntity, NoteEntity])
abstract class AppDatabase extends FloorDatabase {
  NotebookDao get notebookDao;

  NoteDao get noteDao;
}
