# SQLite Notes App

A Flutter notes app backed by **SQLite**, built as a practical learning deliverable for the Flutter SQLite module. It demonstrates local data persistence, full CRUD operations, real-time search, category filtering, and a one-to-many relational schema — all running entirely on-device with no backend required.

---

## Features

- **Create, read, update, and delete notes** via a clean bottom-sheet editor
- **Real-time search** across note titles and content using SQL `LIKE` with a 250 ms debounce
- **Category filter chips** — filter notes by Personal, Work, Study, Ideas, or any custom category
- **One-to-many relationship** — categories linked to notes with a foreign key and `LEFT JOIN`
- **Persistent storage** — database survives app restarts; stored in the app documents directory
- **Cross-platform** — works on Android, iOS, Windows, macOS, and Linux

---

## Screenshots

> Run `flutter run` and the app launches with an empty note list. Tap **Add Note** to create your first entry.

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Language | Dart 3 (SDK `^3.11.5`) |
| Framework | Flutter — Material 3 |
| Database | SQLite via `sqflite ^2.4.2+1` |
| Path utility | `path ^1.9.1` |
| Desktop SQLite | `sqflite_common_ffi ^2.4.0+3` |
| Lint | `flutter_lints ^6.0.0` |

---

## Project Structure

```
lib/
├── data/
│   └── database_helper.dart        # Singleton DB access — all SQL lives here
├── models/
│   ├── note.dart                   # Immutable Note model with toMap / fromMap
│   └── note_category.dart          # NoteCategory model
├── pages/
│   └── notes_page.dart             # Full UI: list, search, filter, CRUD
├── src/
│   ├── database_initializer.dart         # Conditional import router
│   ├── database_initializer_io.dart      # sqflite_common_ffi setup (desktop)
│   └── database_initializer_stub.dart    # No-op stub (mobile / web)
└── main.dart                       # App entry point
```

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed and on `PATH`
- A connected device, emulator, or desktop target

### Run

```bash
# 1. Fetch dependencies
flutter pub get

# 2. Run on the default connected device
flutter run

# Or target a specific platform
flutter run -d android
flutter run -d ios
flutter run -d windows
flutter run -d macos
flutter run -d linux
```

On first launch four default categories (**Personal**, **Work**, **Study**, **Ideas**) are seeded automatically. No manual setup is required.

---

## Database Schema

```sql
CREATE TABLE categories (
  id    INTEGER PRIMARY KEY AUTOINCREMENT,
  name  TEXT NOT NULL UNIQUE
);

CREATE TABLE notes (
  id           INTEGER PRIMARY KEY AUTOINCREMENT,
  title        TEXT NOT NULL,
  content      TEXT NOT NULL,
  category_id  INTEGER NOT NULL,
  created_at   TEXT NOT NULL,   -- ISO-8601 string
  updated_at   TEXT NOT NULL,   -- ISO-8601 string
  FOREIGN KEY (category_id) REFERENCES categories (id)
    ON DELETE RESTRICT
);
```

Foreign key enforcement is enabled at runtime via `PRAGMA foreign_keys = ON`.

---

## SQL Topics Covered

| SQL Feature | Where Used |
|-------------|-----------|
| `CREATE TABLE` | `_createDatabase()` in `DatabaseHelper` |
| `FOREIGN KEY` / `PRAGMA foreign_keys` | Schema definition + `_configureDatabase()` |
| `INSERT` | `insertNote()`, `insertCategory()` |
| Batch `INSERT` | `_seedCategories()` — default category seeding |
| `SELECT` with `JOIN` | `getNotes()`, `getNoteById()` — resolves category name |
| `WHERE` (`LIKE`, `=`) | `getNotes()` — full-text search + category filter |
| `ORDER BY` | `getNotes()` — sorts by `updated_at DESC, id DESC` |
| `LIMIT` / `OFFSET` | `getNotes()` — pagination-ready (default 100 / 0) |
| `UPDATE` | `updateNote()` |
| `DELETE` | `deleteNote()` |

---

## Key Implementation Details

### DatabaseHelper — Singleton with Lazy Init

```dart
class DatabaseHelper {
  DatabaseHelper._(); // private constructor
  static final DatabaseHelper instance = DatabaseHelper._();

  Future<Database>? _database;

  Future<Database> get database async {
    _database ??= _openDatabase(); // opens only on first access
    return _database!;
  }
}
```

### Dynamic WHERE Clause

`getNotes()` builds the `WHERE` clause at runtime from optional parameters, preventing SQL injection via positional `?` arguments:

```dart
if (searchQuery != null && searchQuery.trim().isNotEmpty) {
  whereClauses.add('(n.title LIKE ? OR n.content LIKE ?)');
  whereArgs.addAll(['%$searchQuery%', '%$searchQuery%']);
}
if (categoryId != null) {
  whereClauses.add('n.category_id = ?');
  whereArgs.add(categoryId);
}
```

### LEFT JOIN Query

Notes and categories are resolved in a single round-trip:

```sql
SELECT
  n.id, n.title, n.content, n.category_id,
  n.created_at, n.updated_at,
  c.name AS category_name
FROM notes n
LEFT JOIN categories c ON c.id = n.category_id
WHERE ...
ORDER BY n.updated_at DESC, n.id DESC
LIMIT ? OFFSET ?
```

### Cross-Platform Desktop Support

Dart's conditional import pattern selects the right SQLite factory at compile time — no runtime branching in `main.dart`:

```dart
// database_initializer.dart
import 'database_initializer_stub.dart'
    if (dart.library.io) 'database_initializer_io.dart';
```

On desktop, `sqfliteFfiInit()` and `databaseFactoryFfi` are set before `runApp()`.

---

## Data Models

Both models are **immutable** (`final` fields, `const` constructors) and use explicit casts in `fromMap()` for type safety.

### Note

| Field | Type | Notes |
|-------|------|-------|
| `id` | `int?` | Null before insert; assigned by `AUTOINCREMENT` |
| `title` | `String` | Required |
| `content` | `String` | Required |
| `categoryId` | `int` | Foreign key |
| `categoryName` | `String?` | Populated by `JOIN`; absent in raw rows |
| `createdAt` | `DateTime` | Set on create; never overwritten |
| `updatedAt` | `DateTime` | Updated on every edit; used for sort order |

`Note.copyWith()` provides an immutable update pattern — the UI creates modified copies rather than mutating originals.

`toInsertMap()` excludes `id` and `toUpdateMap()` excludes both `id` and `createdAt`, enforcing correct SQL semantics at the type level.

---

## Possible Enhancements

- **Pagination** — `getNotes()` already accepts `limit` / `offset`; wire up infinite scroll in the UI
- **Category management UI** — `insertCategory()` is already implemented in `DatabaseHelper`
- **FTS5 full-text search** — replace `LIKE` with a virtual FTS5 table for faster search on large datasets
- **Database migrations** — add an `onUpgrade` callback for schema version bumps
- **Repository pattern** — introduce a `NoteRepository` interface to enable unit testing with mocks
- **Export** — serialize notes via `toInsertMap()` and share as JSON or CSV

---

## License

This project is provided for educational purposes as part of the Flutter SQLite learning module.
