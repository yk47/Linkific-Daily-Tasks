import 'package:floor/floor.dart';

import 'notebook_entity.dart';

@Entity(
  tableName: 'notes',
  foreignKeys: [
    ForeignKey(
      childColumns: ['notebook_id'],
      parentColumns: ['id'],
      entity: NotebookEntity,
      onDelete: ForeignKeyAction.cascade,
    ),
  ],
  indices: [
    Index(value: ['notebook_id']),
  ],
)
class NoteEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  @ColumnInfo(name: 'notebook_id')
  final int notebookId;

  final String title;

  final String content;

  @ColumnInfo(name: 'created_at')
  final int createdAtMillis;

  @ColumnInfo(name: 'updated_at')
  final int updatedAtMillis;

  const NoteEntity({
    required this.id,
    required this.notebookId,
    required this.title,
    required this.content,
    required this.createdAtMillis,
    required this.updatedAtMillis,
  });

  NoteEntity copyWith({
    int? id,
    int? notebookId,
    String? title,
    String? content,
    int? createdAtMillis,
    int? updatedAtMillis,
  }) {
    return NoteEntity(
      id: id ?? this.id,
      notebookId: notebookId ?? this.notebookId,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAtMillis: createdAtMillis ?? this.createdAtMillis,
      updatedAtMillis: updatedAtMillis ?? this.updatedAtMillis,
    );
  }
}
