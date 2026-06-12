import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:rest_api_app/controllers/country_contoller.dart';
import 'package:rest_api_app/models/country.dart';
import 'package:rest_api_app/services/api_service.dart';
import 'package:rest_api_app/services/country_service.dart';

import '../services/api_service_test.mocks.dart';

void main() {
  group('CountryController', () {
    late MockClient mockClient;
    late CountryController controller;

    setUp(() {
      mockClient = MockClient();
      final apiService = ApiService(client: mockClient);
      final countryService = CountryService(api: apiService);
      controller = CountryController(service: countryService);
    });

    test('should have initial values', () {
      expect(controller.countries, isEmpty);
      expect(controller.isLoading.value, false);
      expect(controller.error.value, '');
    });

    test('should load countries on successful search', () async {
      final mockResponse = [
        {
          'name': {'common': 'India'},
          'capital': ['New Delhi'],
          'region': 'Asia',
          'flags': {'png': 'https://flagcdn.com/in.png'},
          'population': 1380004385,
          'currencies': {
            'INR': {'name': 'Indian Rupee'}
          },
        }
      ];

      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response(jsonEncode(mockResponse), 200),
      );

      await controller.search('India');

      expect(controller.countries.length, 1);
      expect(controller.countries[0].name, 'India');
      expect(controller.countries[0].capital, 'New Delhi');
      expect(controller.isLoading.value, false);
      expect(controller.error.value, '');
    });

    test('should handle search failure gracefully', () async {
      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response('Not Found', 404),
      );

      await controller.search('UnknownPlace');

      expect(controller.countries, isEmpty);
      expect(controller.error.value, contains('No country found'));
      expect(controller.isLoading.value, false);
    });

    test('should clear previous results on error', () async {
      // First, load a successful result
      final mockResponse = [
        {
          'name': {'common': 'France'},
          'capital': ['Paris'],
          'region': 'Europe',
          'flags': {'png': 'https://flagcdn.com/fr.png'},
          'population': 67391582,
          'currencies': {
            'EUR': {'name': 'Euro'}
          },
        }
      ];

      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response(jsonEncode(mockResponse), 200),
      );

      await controller.search('France');
      expect(controller.countries.length, 1);

      // Then fail
      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response('Not Found', 404),
      );

      await controller.search('Nowhere');

      expect(controller.countries, isEmpty);
      expect(controller.error.value, isNotEmpty);
    });

    test('should handle search with empty query', () async {
      // The controller doesn't guard against empty queries, but service should handle it
      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response(jsonEncode([]), 200),
      );

      await controller.search('');

      expect(controller.isLoading.value, false);
    });

    test('should update loading state correctly', () async {
      final mockResponse = [
        {
          'name': {'common': 'Test'},
          'capital': ['Test'],
          'region': 'Test',
          'flags': {'png': ''},
          'population': 100,
          'currencies': {},
        }
      ];

      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response(jsonEncode(mockResponse), 200),
      );

      final future = controller.search('Test');
      expect(controller.isLoading.value, true);

      await future;
      expect(controller.isLoading.value, false);
    });
  });
}