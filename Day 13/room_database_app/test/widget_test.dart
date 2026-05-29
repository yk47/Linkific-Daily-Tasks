import 'package:flutter_test/flutter_test.dart';

import 'package:room_database/app.dart';
import 'package:room_database/data/in_memory_notes_repository.dart';
import 'package:room_database/data/note_entity.dart';

void main() {
  testWidgets('renders notes from the repository', (WidgetTester tester) async {
    final repository = InMemoryNotesRepository(
      seedNotes: [
        NoteEntity(
          id: 1,
          notebookId: 1,
          title: 'Test note',
          content: 'Created from the in-memory repository.',
          createdAtMillis: 1710000000000,
          updatedAtMillis: 1710000000000,
        ),
      ],
    );

    await tester.pumpWidget(MyApp(repository: repository));
    await tester.pumpAndSettle();

    expect(find.text('Test note'), findsOneWidget);
    expect(find.textContaining('Floor Notes'), findsOneWidget);
  });
}
