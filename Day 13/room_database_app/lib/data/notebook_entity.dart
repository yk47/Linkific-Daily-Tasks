import 'package:floor/floor.dart';

@Entity(tableName: 'notebooks')
class NotebookEntity {
  @PrimaryKey(autoGenerate: false)
  final int id;

  final String name;

  @ColumnInfo(name: 'created_at')
  final int createdAtMillis;

  const NotebookEntity({
    required this.id,
    required this.name,
    required this.createdAtMillis,
  });
}
