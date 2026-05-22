// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:todo_list_app/main.dart';

void main() {
  testWidgets('can add, toggle, edit, search, and delete todos', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(
      find.byKey(const Key('todoInput')),
      'Learn setState',
    );
    await tester.tap(find.byKey(const Key('addTodoButton')));
    await tester.pumpAndSettle();

    expect(find.text('Learn setState'), findsOneWidget);

    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();

    expect(find.text('Completed'), findsOneWidget);

    await tester.tap(find.byTooltip('Edit task'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).last, 'Master setState');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Master setState'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('searchField')), 'master');
    await tester.pumpAndSettle();

    expect(find.text('Master setState'), findsOneWidget);

    await tester.tap(find.byTooltip('Delete task'));
    await tester.pumpAndSettle();

    expect(find.text('No tasks match your search'), findsOneWidget);
  });
}
