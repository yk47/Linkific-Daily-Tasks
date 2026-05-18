import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:basic_ui/main.dart';

void main() {
  testWidgets('shows the learning home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Basic UI Lab'), findsOneWidget);
    expect(find.text('Widget tree snapshot'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Stateless widget example'), 300);
    await tester.pumpAndSettle();

    expect(find.byType(FilledButton), findsWidgets);
  });
}
