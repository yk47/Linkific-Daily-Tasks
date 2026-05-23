import 'package:flutter_test/flutter_test.dart';

import 'package:navigation_/main.dart';

void main() {
  testWidgets('named route returns data to the home screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Navigation Home'), findsOneWidget);
    expect(find.text('Open named detail'), findsOneWidget);

    await tester.ensureVisible(find.text('Open named detail'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Open named detail'));
    await tester.pumpAndSettle();

    expect(find.byType(DetailScreen), findsOneWidget);
    expect(find.text('Send result back'), findsOneWidget);

    await tester.tap(find.text('Send result back'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Accepted from named detail'), findsOneWidget);
  });
}
