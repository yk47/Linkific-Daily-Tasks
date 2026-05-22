import 'package:flutter_test/flutter_test.dart';

import 'package:quiz_app/main.dart';

void main() {
  testWidgets('completes the quiz and shows the final score', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('setState()'));
    await tester.pump();
    await tester.scrollUntilVisible(find.text('Next question'), 300);
    await tester.tap(find.text('Next question'));
    await tester.pump();

    await tester.tap(find.text('StatefulWidget'));
    await tester.pump();
    await tester.scrollUntilVisible(find.text('Next question'), 300);
    await tester.tap(find.text('Next question'));
    await tester.pump();

    await tester.tap(find.text('TextEditingController'));
    await tester.pump();
    await tester.scrollUntilVisible(find.text('Finish quiz'), 300);
    await tester.tap(find.text('Finish quiz'));
    await tester.pump();

    expect(find.text('Quiz complete'), findsOneWidget);
    expect(find.text('You scored 3 out of 3.'), findsOneWidget);

    await tester.tap(find.text('Restart quiz'));
    await tester.pump();

    expect(find.text('Question 1 of 3'), findsOneWidget);
    expect(find.text('Quiz complete'), findsNothing);
  });
}
