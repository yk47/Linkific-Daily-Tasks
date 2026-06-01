import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shared_preferences_app/features/settings/screens/settings_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('loads saved preferences on startup', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'theme_mode': true,
      'language_code': 'es',
      'notifications_enabled': false,
      'remember_login': true,
      'logged_in': true,
      'display_name': 'Ava',
      'font_scale': 1.2,
      'launch_count': 4,
      'favorite_topics': <String>['Flutter', 'Settings'],
    });

    await tester.pumpWidget(const SettingsScreen());
    await tester.pumpAndSettle();

    expect(find.text('Laboratorio de Shared Preferences'), findsOneWidget);
    expect(find.text('Ava'), findsWidgets);
    expect(find.text('5'), findsWidgets);
    expect(find.text('Tema'), findsWidgets);
    expect(find.text('Español'), findsWidgets);
  });

  testWidgets('saves updated profile and settings', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SettingsScreen());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Morgan');
    await tester.ensureVisible(
      find.widgetWithText(FilledButton, 'Save profile'),
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Save profile'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.widgetWithText(OutlinedButton, 'Log in'));
    await tester.tap(find.widgetWithText(OutlinedButton, 'Log in'));
    await tester.pumpAndSettle();

    final SharedPreferences preferences = await SharedPreferences.getInstance();

    expect(preferences.getString('display_name'), 'Morgan');
    expect(preferences.getBool('logged_in'), isTrue);
    expect(preferences.getBool('remember_login'), isTrue);
    expect(preferences.getInt('launch_count'), 1);

    expect(find.text('Morgan'), findsWidgets);
  });
}
