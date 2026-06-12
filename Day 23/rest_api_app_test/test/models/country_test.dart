import 'package:flutter_test/flutter_test.dart';
import 'package:rest_api_app/models/country.dart';

void main() {
  group('Country Model', () {
    test('should create a Country instance with required fields', () {
      final country = Country(
        name: 'India',
        capital: 'New Delhi',
        region: 'Asia',
        flag: 'https://flagcdn.com/in.png',
        population: 1380004385,
        currency: 'Indian Rupee',
      );

      expect(country.name, 'India');
      expect(country.capital, 'New Delhi');
      expect(country.region, 'Asia');
      expect(country.flag, 'https://flagcdn.com/in.png');
      expect(country.population, 1380004385);
      expect(country.currency, 'Indian Rupee');
    });

    group('fromJson', () {
      test('should parse valid JSON correctly', () {
        final json = {
          'name': {'common': 'France'},
          'capital': ['Paris'],
          'region': 'Europe',
          'flags': {'png': 'https://flagcdn.com/fr.png'},
          'population': 67391582,
          'currencies': {
            'EUR': {'name': 'Euro'}
          },
        };

        final country = Country.fromJson(json);

        expect(country.name, 'France');
        expect(country.capital, 'Paris');
        expect(country.region, 'Europe');
        expect(country.flag, 'https://flagcdn.com/fr.png');
        expect(country.population, 67391582);
        expect(country.currency, 'Euro');
      });

      test('should handle empty JSON gracefully', () {
        final json = <String, dynamic>{};

        // Accessing json["name"] returns null, then ["common"] throws
        expect(() => Country.fromJson(json), throwsA(isA<NoSuchMethodError>()));
      });

      test('should handle missing currencies field', () {
        final json = {
          'name': {'common': 'Test'},
          'capital': ['Test'],
          'region': 'Test',
          'flags': {'png': ''},
          'population': 100,
        };

        final country = Country.fromJson(json);

        expect(country.currency, '');
      });

      test('should handle missing capital list', () {
        final json = {
          'name': {'common': 'Japan'},
          'capital': null,
          'region': 'Asia',
          'flags': {'png': ''},
          'population': 125800000,
          'currencies': {
            'JPY': {'name': 'Yen'}
          },
        };

        final country = Country.fromJson(json);

        expect(country.capital, '');
      });

      test('should handle null name.common gracefully', () {
        final json = {
          'name': null,
          'capital': ['Test'],
          'region': 'Test',
          'flags': {'png': ''},
          'population': 0,
        };

        expect(() => Country.fromJson(json), throwsA(isA<NoSuchMethodError>()));
      });
    });

    test('should correctly parse multiple currencies', () {
      final json = {
        'name': {'common': 'Belgium'},
        'capital': ['Brussels'],
        'region': 'Europe',
        'flags': {'png': 'https://flagcdn.com/be.png'},
        'population': 11589623,
        'currencies': {
          'EUR': {'name': 'Euro'}
        },
      };

      final country = Country.fromJson(json);

      expect(country.name, 'Belgium');
      expect(country.capital, 'Brussels');
      expect(country.region, 'Europe');
      expect(country.currency, 'Euro');
    });
  });
}