import 'package:flutter_test/flutter_test.dart';
import 'package:rest_api_app/models/weather.dart';

void main() {
  group('Weather Model', () {
    test('should create a Weather instance with required fields', () {
      final weather = Weather(
        city: 'London',
        temp: 15.5,
        feelsLike: 13.2,
        humidity: 72,
        description: 'Partly cloudy',
        icon: '02d',
      );

      expect(weather.city, 'London');
      expect(weather.temp, 15.5);
      expect(weather.feelsLike, 13.2);
      expect(weather.humidity, 72);
      expect(weather.description, 'Partly cloudy');
      expect(weather.icon, '02d');
    });

    group('fromJson', () {
      test('should parse valid JSON correctly', () {
        final json = {
          'name': 'Tokyo',
          'main': {
            'temp': 22.3,
            'feels_like': 20.1,
            'humidity': 65,
          },
          'weather': [
            {
              'description': 'Clear sky',
              'icon': '01d',
            }
          ],
        };

        final weather = Weather.fromJson(json);

        expect(weather.city, 'Tokyo');
        expect(weather.temp, 22.3);
        expect(weather.feelsLike, 20.1);
        expect(weather.humidity, 65);
        expect(weather.description, 'Clear sky');
        expect(weather.icon, '01d');
      });

      test('should throw NoSuchMethodError on empty JSON', () {
        final json = <String, dynamic>{};

        expect(() => Weather.fromJson(json), throwsA(isA<NoSuchMethodError>()));
      });

      test('should throw NoSuchMethodError when weather array missing', () {
        final json = {
          'name': 'Test',
          'main': {
            'temp': 10.0,
            'feels_like': 8.0,
            'humidity': 50,
          },
        };

        expect(() => Weather.fromJson(json), throwsA(isA<NoSuchMethodError>()));
      });

      test('should handle temperature with integer value', () {
        final json = {
          'name': 'Berlin',
          'main': {
            'temp': 18,
            'feels_like': 16,
            'humidity': 60,
          },
          'weather': [
            {
              'description': 'Cloudy',
              'icon': '04d',
            }
          ],
        };

        final weather = Weather.fromJson(json);

        expect(weather.city, 'Berlin');
        expect(weather.temp, 18.0);
        expect(weather.feelsLike, 16.0);
        expect(weather.humidity, 60);
        expect(weather.description, 'Cloudy');
        expect(weather.icon, '04d');
      });

      test('should handle zero temperature', () {
        final json = {
          'name': 'Moscow',
          'main': {
            'temp': 0.0,
            'feels_like': -5.0,
            'humidity': 80,
          },
          'weather': [
            {
              'description': 'Snow',
              'icon': '13d',
            }
          ],
        };

        final weather = Weather.fromJson(json);

        expect(weather.city, 'Moscow');
        expect(weather.temp, 0.0);
        expect(weather.feelsLike, -5.0);
        expect(weather.humidity, 80);
        expect(weather.description, 'Snow');
        expect(weather.icon, '13d');
      });
    });

    test('should create identical instances for same JSON', () {
      final json = {
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

      final weather1 = Weather.fromJson(json);
      final weather2 = Weather.fromJson(json);

      expect(weather1.city, weather2.city);
      expect(weather1.temp, weather2.temp);
      expect(weather1.feelsLike, weather2.feelsLike);
      expect(weather1.humidity, weather2.humidity);
      expect(weather1.description, weather2.description);
      expect(weather1.icon, weather2.icon);
    });
  });
}