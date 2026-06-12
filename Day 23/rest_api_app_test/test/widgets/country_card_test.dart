import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:rest_api_app/models/country.dart';
import 'package:rest_api_app/widgets/country_card.dart';

void main() {
  group('CountryCard Widget', () {
    testWidgets('should render country name and capital', (tester) async {
      final country = Country(
        name: 'Japan',
        capital: 'Tokyo',
        region: 'Asia',
        flag: '',
        population: 125800000,
        currency: 'Yen',
      );

      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: CountryCard(country: country),
          ),
        ),
      );

      expect(find.text('Japan'), findsOneWidget);
      expect(find.text('Tokyo'), findsOneWidget);
    });

    testWidgets('should render with flag icon for empty flag', (tester) async {
      final country = Country(
        name: 'France',
        capital: 'Paris',
        region: 'Europe',
        flag: '',
        population: 67391582,
        currency: 'Euro',
      );

      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: CountryCard(country: country),
          ),
        ),
      );

      expect(find.text('France'), findsOneWidget);
      expect(find.text('Paris'), findsOneWidget);
      expect(find.byIcon(Icons.flag), findsOneWidget);
    });

    testWidgets('should have Card and ListTile', (tester) async {
      final country = Country(
        name: 'India',
        capital: 'New Delhi',
        region: 'Asia',
        flag: '',
        population: 1380004385,
        currency: 'Indian Rupee',
      );

      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: CountryCard(country: country),
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(ListTile), findsOneWidget);
    });

    testWidgets('should display name in ListTile title', (tester) async {
      final country = Country(
        name: 'Germany',
        capital: 'Berlin',
        region: 'Europe',
        flag: '',
        population: 83166711,
        currency: 'Euro',
      );

      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: CountryCard(country: country),
          ),
        ),
      );

      final listTile = tester.widget<ListTile>(find.byType(ListTile));
      expect((listTile.title as Text).data, 'Germany');
      expect((listTile.subtitle as Text).data, 'Berlin');
    });
  });
}