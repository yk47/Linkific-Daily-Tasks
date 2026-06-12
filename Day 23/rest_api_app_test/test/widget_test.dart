import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:rest_api_app/main.dart';

void main() {
  group('MyApp Widget', () {
    testWidgets('should render the app without errors', (tester) async {
      await tester.pumpWidget(MyApp());

      // Verify that the app renders with GetMaterialApp
      expect(find.byType(GetMaterialApp), findsOneWidget);
    });

    testWidgets('should have bottom navigation items', (tester) async {
      await tester.pumpWidget(MyApp());

      // Check for navigation labels
      expect(find.text('Countries'), findsOneWidget);
      expect(find.text('News'), findsOneWidget);
      expect(find.text('Weather'), findsOneWidget);
    });
  });

  group('App Initialization', () {
    test('MyApp should create successfully', () {
      expect(MyApp(), isNotNull);
    });
  });
}