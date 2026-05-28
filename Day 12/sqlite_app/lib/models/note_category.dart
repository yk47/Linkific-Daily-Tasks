class NoteCategory {
  const NoteCategory({this.id, required this.name});

  final int? id;
  final String name;

  Map<String, dynamic> toInsertMap() {
    return <String, dynamic>{'name': name};
  }

  factory NoteCategory.fromMap(Map<String, dynamic> map) {
    return NoteCategory(id: map['id'] as int?, name: map['name'] as String);
  }
}
