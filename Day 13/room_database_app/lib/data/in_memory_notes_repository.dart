import 'dart:async';

import 'note_entity.dart';
import 'notes_repository.dart';

class InMemoryNotesRepository implements NotesRepository {
  final List<NoteEntity> _notes = [];
  late final StreamController<List<NoteEntity>> _controller;

  InMemoryNotesRepository({List<NoteEntity> seedNotes = const []}) {
    _controller = StreamController<List<NoteEntity>>.broadcast(onListen: _emit);
    _notes.addAll(seedNotes);
    _notes.sort(
      (left, right) => right.updatedAtMillis.compareTo(left.updatedAtMillis),
    );
  }

  @override
  Stream<List<NoteEntity>> watchNotes() => _controller.stream;

  @override
  Future<NoteEntity?> findNoteById(int id) async {
    for (final note in _notes) {
      if (note.id == id) {
        return note;
      }
    }
    return null;
  }

  @override
  Future<void> saveNote({
    NoteEntity? existing,
    required String title,
    required String content,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (existing == null) {
      final nextId = _notes.isEmpty
          ? 1
          : (_notes
                    .map((note) => note.id ?? 0)
                    .reduce((left, right) => left > right ? left : right) +
                1);
      _notes.insert(
        0,
        NoteEntity(
          id: nextId,
          notebookId: 1,
          title: title.trim(),
          content: content.trim(),
          createdAtMillis: now,
          updatedAtMillis: now,
        ),
      );
    } else {
      final index = _notes.indexWhere((note) => note.id == existing.id);
      if (index != -1) {
        _notes[index] = existing.copyWith(
          title: title.trim(),
          content: content.trim(),
          updatedAtMillis: now,
        );
      }
    }

    _notes.sort(
      (left, right) => right.updatedAtMillis.compareTo(left.updatedAtMillis),
    );
    _emit();
  }

  @override
  Future<void> deleteNote(NoteEntity note) async {
    _notes.removeWhere((item) => item.id == note.id);
    _emit();
  }

  @override
  Future<void> seed() async {}

  void _emit() {
    _controller.add(List<NoteEntity>.unmodifiable(_notes));
  }
}
