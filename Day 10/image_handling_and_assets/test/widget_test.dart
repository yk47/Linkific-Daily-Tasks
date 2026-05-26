import 'package:flutter_test/flutter_test.dart';

import 'package:image_handling_and_assets/main.dart';

void main() {
  testWidgets('image handling app renders main title', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ImageHandlingApp());

    expect(find.text('Flutter Image Handling Demo'), findsOneWidget);
  });
}
