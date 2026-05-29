import 'package:flutter/material.dart';

import 'app.dart';
import 'data/app_database.dart';
import 'data/floor_notes_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = await $FloorAppDatabase
      .databaseBuilder('room_database.db')
      .build();
  final repository = FloorNotesRepository(database);
  await repository.seed();

  runApp(MyApp(repository: repository));
}
