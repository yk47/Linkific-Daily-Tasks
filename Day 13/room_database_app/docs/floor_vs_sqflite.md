# sqflite vs Floor

## Floor

Floor is an ORM-style abstraction on top of SQLite. You define entities, DAOs, and a database class, then generate the implementation with build_runner.

### Strengths

- Type-safe queries and mapped entities.
- Stream-based queries for reactive UIs.
- Clear separation between schema, queries, and app code.
- Less boilerplate once the pattern is set up.

### Trade-offs

- Requires code generation.
- You still need SQL knowledge for good queries.
- Schema changes need migrations as the app grows.

## sqflite

sqflite is a lower-level SQLite wrapper. You write the SQL, manage mapping, and usually hand-roll repository code.

### Strengths

- Very direct and flexible.
- Easier to reason about if you want full SQL control.
- No code generation step.

### Trade-offs

- More boilerplate for CRUD and row mapping.
- Less compile-time safety.
- More repetitive code for larger schemas.

## When to use which

- Use sqflite for small, straightforward apps or when you want direct SQL everywhere.
- Use Floor when you want a structured data layer, type safety, and reactive streams.
- Performance is usually similar because both still use SQLite under the hood.

## This project

This app uses Floor with:

- `NotebookEntity` and `NoteEntity` for the schema.
- `NotebookDao` and `NoteDao` for queries and CRUD.
- A foreign-key relationship from notes to notebooks.
- A stream-powered UI that refreshes automatically when the database changes.
