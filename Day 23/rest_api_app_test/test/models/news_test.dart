import 'package:flutter_test/flutter_test.dart';
import 'package:rest_api_app/models/news.dart';

void main() {
  group('News Model', () {
    test('should create a News instance with required fields', () {
      final news = News(
        title: 'Test Title',
        description: 'Test Description',
        image: 'https://example.com/image.jpg',
        source: 'Test Source',
        url: 'https://example.com/article',
        publishedAt: '2024-01-01T00:00:00Z',
      );

      expect(news.title, 'Test Title');
      expect(news.description, 'Test Description');
      expect(news.image, 'https://example.com/image.jpg');
      expect(news.source, 'Test Source');
      expect(news.url, 'https://example.com/article');
      expect(news.publishedAt, '2024-01-01T00:00:00Z');
    });

    group('fromJson', () {
      test('should parse valid JSON correctly', () {
        final json = {
          'title': 'Breaking News',
          'description': 'Something important happened',
          'urlToImage': 'https://example.com/news.jpg',
          'source': {'name': 'BBC News'},
          'url': 'https://example.com/story',
          'publishedAt': '2024-06-12T10:30:00Z',
        };

        final news = News.fromJson(json);

        expect(news.title, 'Breaking News');
        expect(news.description, 'Something important happened');
        expect(news.image, 'https://example.com/news.jpg');
        expect(news.source, 'BBC News');
        expect(news.url, 'https://example.com/story');
        expect(news.publishedAt, '2024-06-12T10:30:00Z');
      });

      test('should handle null values gracefully', () {
        final json = <String, dynamic>{};

        final news = News.fromJson(json);

        expect(news.title, '');
        expect(news.description, '');
        expect(news.image, '');
        expect(news.source, '');
        expect(news.url, '');
        expect(news.publishedAt, '');
      });

      test('should handle empty values', () {
        final json = {
          'title': '',
          'description': '',
          'urlToImage': '',
          'source': null,
          'url': '',
          'publishedAt': '',
        };

        final news = News.fromJson(json);

        expect(news.title, '');
        expect(news.description, '');
        expect(news.image, '');
        expect(news.source, '');
        expect(news.url, '');
        expect(news.publishedAt, '');
      });

      test('should handle missing source name', () {
        final json = {
          'title': 'News Title',
          'description': 'Description',
          'urlToImage': 'https://example.com/img.jpg',
          'source': {'id': 'bbc-news'},
          'url': 'https://example.com',
          'publishedAt': '2024-01-01T00:00:00Z',
        };

        final news = News.fromJson(json);

        expect(news.source, '');
      });

      test('should throw exception when source is not a Map', () {
        final json = {
          'title': 'Title',
          'description': 'Desc',
          'urlToImage': 'https://example.com/img.jpg',
          'source': 'BBC News',
          'url': 'https://example.com',
          'publishedAt': '2024-01-01T00:00:00Z',
        };

        expect(() => News.fromJson(json), throwsA(isA<TypeError>()));
      });
    });

    test('should create identical instances for same JSON', () {
      final json = {
        'title': 'Test',
        'description': 'Test desc',
        'urlToImage': 'https://example.com/img.jpg',
        'source': {'name': 'Source'},
        'url': 'https://example.com',
        'publishedAt': '2024-01-01T00:00:00Z',
      };

      final news1 = News.fromJson(json);
      final news2 = News.fromJson(json);

      expect(news1.title, news2.title);
      expect(news1.description, news2.description);
      expect(news1.image, news2.image);
      expect(news1.source, news2.source);
      expect(news1.url, news2.url);
      expect(news1.publishedAt, news2.publishedAt);
    });
  });
}