// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:material_theme_customization_app/main.dart';

void main() {
  testWidgets('shows the themed showcase and theme switcher', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp(initialMode: ThemeMode.light));

    expect(find.text('Theme Studio'), findsWidgets);
    expect(find.text('Custom color scheme'), findsOneWidget);
    expect(find.text('Active theme: Light'), findsOneWidget);
    expect(find.text('Primary'), findsOneWidget);
    expect(find.text('System'), findsOneWidget);
    expect(find.text('Dark'), findsOneWidget);
  });
}
