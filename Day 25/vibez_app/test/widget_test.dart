import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:vibez_app/main.dart';
import 'package:vibez_app/src/controllers/auth_controller.dart';
import 'package:vibez_app/src/controllers/social_controller.dart';
import 'package:vibez_app/src/controllers/chat_controller.dart';

void main() {
  testWidgets('App should render splash screen', (WidgetTester tester) async {
    // Initialize GetX controllers
    Get.put(AuthController(), permanent: true);
    Get.put(SocialController(), permanent: true);
    Get.put(ChatController(), permanent: true);

    await tester.pumpWidget(const VibezApp());
    
    // Check if the app title is present
    expect(find.text('Vibez'), findsOneWidget);
    expect(find.text('Share Your Vibez'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Clean up
    Get.reset();
  });

  testWidgets('App should have GetMaterialApp setup', (WidgetTester tester) async {
    await tester.pumpWidget(const VibezApp());
    
    // Verify that GetMaterialApp is working
    expect(find.byType(GetMaterialApp), findsOneWidget);

    // Clean up
    Get.reset();
  });
}