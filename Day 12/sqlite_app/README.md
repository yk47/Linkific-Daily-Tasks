# SQLite Notes App

A Flutter notes app backed by SQLite. It demonstrates local persistence, CRUD operations, search, filtering, and a simple one-to-many relationship between notes and categories.

## Features

- Create, read, update, and delete notes
- Search notes with `WHERE` clauses
- Filter by category
- Join notes with categories for display
- Persist data locally with SQLite
- Desktop-friendly initialization via `sqflite_common_ffi`

## Packages

- `sqflite`
- `path`
- `sqflite_common_ffi` for Windows, macOS, and Linux desktop runs

## Structure

- [lib/main.dart](lib/main.dart) bootstraps the app and initializes SQLite on desktop
- [lib/data/database_helper.dart](lib/data/database_helper.dart) contains the database helper and CRUD logic
- [lib/models/note.dart](lib/models/note.dart) defines the note model
- [lib/models/note_category.dart](lib/models/note_category.dart) defines the category model
- [lib/pages/notes_page.dart](lib/pages/notes_page.dart) provides the UI for CRUD and search

## SQLite Topics Covered

- `CREATE TABLE`
- `INSERT`
- `SELECT`
- `UPDATE`
- `DELETE`
- `WHERE`
- `ORDER BY`
- `LIMIT` and `OFFSET`
- `JOIN`

## Run

```bash
flutter pub get
flutter run
```

## Notes

- Default categories are seeded automatically on first launch.
- The database is stored in the app documents directory and survives app restarts.
