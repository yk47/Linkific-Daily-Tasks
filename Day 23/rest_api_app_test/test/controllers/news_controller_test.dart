import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:rest_api_app/controllers/news_controller.dart';
import 'package:rest_api_app/services/api_service.dart';
import 'package:rest_api_app/services/news_service.dart';

import '../services/api_service_test.mocks.dart';

void main() {
  group('NewsController', () {
    late MockClient mockClient;
    late NewsController controller;

    setUp(() {
      mockClient = MockClient();
      final apiService = ApiService(client: mockClient);
      final newsService = NewsService(api: apiService);
      controller = NewsController(service: newsService);
    });

    test('should have initial values', () {
      expect(controller.newsList, isEmpty);
      expect(controller.isLoading.value, false);
      expect(controller.error.value, '');
    });

    test('should load top headlines on init', () async {
      final mockResponse = {
        'articles': [
          {
            'title': 'Breaking News',
            'description': 'Something happened',
            'urlToImage': 'https://example.com/img.jpg',
            'source': {'name': 'BBC'},
            'url': 'https://example.com/article',
            'publishedAt': '2024-01-01T00:00:00Z',
          }
        ]
      };

      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response(jsonEncode(mockResponse), 200),
      );

      await controller.fetchTopHeadlines();

      expect(controller.newsList.length, 1);
      expect(controller.newsList[0].title, 'Breaking News');
      expect(controller.newsList[0].source, 'BBC');
      expect(controller.isLoading.value, false);
      expect(controller.error.value, '');
    });

    test('should handle fetch failure gracefully', () async {
      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response('Forbidden', 403),
      );

      await controller.fetchTopHeadlines();

      expect(controller.newsList, isEmpty);
      expect(controller.error.value, isNotEmpty);
      expect(controller.isLoading.value, false);
    });

    test('should search news successfully', () async {
      final mockResponse = {
        'articles': [
          {
            'title': 'Flutter News',
            'description': 'Flutter framework update',
            'urlToImage': 'https://example.com/flutter.jpg',
            'source': {'name': 'Tech News'},
            'url': 'https://example.com/flutter-news',
            'publishedAt': '2024-06-12T10:00:00Z',
          }
        ]
      };

      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response(jsonEncode(mockResponse), 200),
      );

      await controller.searchNews('Flutter');

      expect(controller.newsList.length, 1);
      expect(controller.newsList[0].title, 'Flutter News');
      expect(controller.isLoading.value, false);
    });

    test('should call fetchTopHeadlines when search query is empty', () async {
      final mockResponse = {
        'articles': [
          {
            'title': 'Headline',
            'description': 'Top headline',
            'urlToImage': 'https://example.com/img.jpg',
            'source': {'name': 'News'},
            'url': 'https://example.com',
            'publishedAt': '2024-01-01T00:00:00Z',
          }
        ]
      };

      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response(jsonEncode(mockResponse), 200),
      );

      await controller.searchNews('   ');

      expect(controller.newsList.length, 1);
      expect(controller.newsList[0].title, 'Headline');
    });

    test('should handle search failure gracefully', () async {
      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response('Not Found', 404),
      );

      await controller.searchNews('Nonexistent');

      expect(controller.newsList, isEmpty);
      expect(controller.error.value, isNotEmpty);
      expect(controller.isLoading.value, false);
    });

    test('should update loading state during fetch', () async {
      final mockResponse = {
        'articles': [
          {
            'title': 'Test',
            'description': 'Test',
            'urlToImage': '',
            'source': {'name': 'Test'},
            'url': '',
            'publishedAt': '2024-01-01T00:00:00Z',
          }
        ]
      };

      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response(jsonEncode(mockResponse), 200),
      );

      expect(controller.isLoading.value, false);

      final future = controller.fetchTopHeadlines();
      expect(controller.isLoading.value, true);

      await future;
      expect(controller.isLoading.value, false);
    });
  });
}