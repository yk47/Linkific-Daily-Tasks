import 'package:flutter_test/flutter_test.dart';

import 'package:permission_handling/app.dart';

void main() {
  testWidgets('renders permission handling home screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PermissionHandlingApp());

    expect(find.text('Permission Handling'), findsOneWidget);
    expect(find.text('Request core permissions'), findsOneWidget);
  });
}
