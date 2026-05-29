# Room Database App

This Flutter app demonstrates Floor as a Room-style SQLite alternative.

## What’s included

- Floor entities, DAO interfaces, and a generated database.
- CRUD notes UI with live stream updates.
- A foreign-keyed notebook relationship.
- A comparison guide for sqflite vs Floor.

## Core files

- [lib/data/app_database.dart](lib/data/app_database.dart)
- [lib/data/note_entity.dart](lib/data/note_entity.dart)
- [lib/data/note_dao.dart](lib/data/note_dao.dart)
- [lib/data/notebook_entity.dart](lib/data/notebook_entity.dart)
- [lib/data/notebook_dao.dart](lib/data/notebook_dao.dart)
- [lib/data/floor_notes_repository.dart](lib/data/floor_notes_repository.dart)
- [lib/app.dart](lib/app.dart)

## Floor setup

1. Add `floor`, `sqflite`, `floor_generator`, and `build_runner`.
2. Define your entities with `@Entity`, `@PrimaryKey`, and `@ColumnInfo`.
3. Define DAOs with `@dao`, `@Query`, `@Insert`, `@Update`, and `@Delete`.
4. Create a `@Database` class that extends `FloorDatabase`.
5. Run the generator.

## Generate code

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Compare Floor and sqflite

Read [docs/floor_vs_sqflite.md](docs/floor_vs_sqflite.md) for a short comparison and guidance on when to use each.

## Notes

The app seeds a default notebook and uses a stream query so the UI updates automatically after insert, update, and delete operations.
