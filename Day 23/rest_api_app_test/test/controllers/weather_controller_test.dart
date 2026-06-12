import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:rest_api_app/controllers/weather_controller.dart';
import 'package:rest_api_app/services/api_service.dart';
import 'package:rest_api_app/services/weather_service.dart';

import '../services/api_service_test.mocks.dart';

void main() {
  group('WeatherController', () {
    late MockClient mockClient;
    late WeatherController controller;

    setUp(() {
      mockClient = MockClient();
      final apiService = ApiService(client: mockClient);
      final weatherService = WeatherService(api: apiService);
      controller = WeatherController(service: weatherService);
    });

    test('should have initial values', () {
      expect(controller.weather.value, isNull);
      expect(controller.isLoading.value, false);
      expect(controller.error.value, '');
    });

    test('should fetch weather successfully', () async {
      final mockResponse = {
        'name': 'London',
        'main': {
          'temp': 15.5,
          'feels_like': 13.2,
          'humidity': 72,
        },
        'weather': [
          {
            'description': 'Partly cloudy',
            'icon': '02d',
          }
        ],
      };

      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response(jsonEncode(mockResponse), 200),
      );

      await controller.fetchWeather('London');

      expect(controller.weather.value, isNotNull);
      expect(controller.weather.value!.city, 'London');
      expect(controller.weather.value!.temp, 15.5);
      expect(controller.weather.value!.humidity, 72);
      expect(controller.weather.value!.description, 'Partly cloudy');
      expect(controller.isLoading.value, false);
      expect(controller.error.value, '');
    });

    test('should handle fetch failure gracefully', () async {
      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response('Not Found', 404),
      );

      await controller.fetchWeather('NonexistentCity');

      expect(controller.weather.value, isNull);
      expect(controller.error.value, 'City not found');
      expect(controller.isLoading.value, false);
    });

    test('should not fetch weather for empty city', () async {
      await controller.fetchWeather('');

      expect(controller.weather.value, isNull);
      expect(controller.isLoading.value, false);
      expect(controller.error.value, '');
    });

    test('should not fetch weather for whitespace-only city', () async {
      await controller.fetchWeather('   ');

      expect(controller.weather.value, isNull);
      expect(controller.isLoading.value, false);
      expect(controller.error.value, '');
    });

    test('should update loading state during fetch', () async {
      final mockResponse = {
        'name': 'Paris',
        'main': {
          'temp': 20.0,
          'feels_like': 18.0,
          'humidity': 55,
        },
        'weather': [
          {
            'description': 'Sunny',
            'icon': '01d',
          }
        ],
      };

      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response(jsonEncode(mockResponse), 200),
      );

      expect(controller.isLoading.value, false);

      final future = controller.fetchWeather('Paris');
      expect(controller.isLoading.value, true);

      await future;
      expect(controller.isLoading.value, false);
    });

    test('should update weather when fetching different cities', () async {
      final londonResponse = {
        'name': 'London',
        'main': {'temp': 15.0, 'feels_like': 13.0, 'humidity': 70},
        'weather': [{'description': 'Cloudy', 'icon': '04d'}],
      };

      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response(jsonEncode(londonResponse), 200),
      );

      await controller.fetchWeather('London');
      expect(controller.weather.value!.city, 'London');

      final parisResponse = {
        'name': 'Paris',
        'main': {'temp': 22.0, 'feels_like': 20.0, 'humidity': 50},
        'weather': [{'description': 'Clear', 'icon': '01d'}],
      };

      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response(jsonEncode(parisResponse), 200),
      );

      await controller.fetchWeather('Paris');
      expect(controller.weather.value!.city, 'Paris');
      expect(controller.weather.value!.temp, 22.0);
    });
  });
}