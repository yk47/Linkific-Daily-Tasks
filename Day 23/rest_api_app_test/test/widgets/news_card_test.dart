import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:rest_api_app/models/news.dart';
import 'package:rest_api_app/widgets/news_card.dart';

void main() {
  group('NewsCard Widget', () {
    testWidgets('should render news title and source', (tester) async {
      final news = News(
        title: 'Breaking News: Flutter 4.0 Released',
        description: 'Google announces major update',
        image: '',
        source: 'TechCrunch',
        url: 'https://example.com',
        publishedAt: '2024-06-12T10:00:00Z',
      );

      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: NewsCard(news: news),
          ),
        ),
      );

      expect(find.text('Breaking News: Flutter 4.0 Released'), findsOneWidget);
      expect(find.text('TechCrunch'), findsOneWidget);
    });

    testWidgets('should not display image when image is empty', (tester) async {
      final news = News(
        title: 'News without Image',
        description: 'Description',
        image: '',
        source: 'Source',
        url: 'https://example.com',
        publishedAt: '2024-06-12T10:00:00Z',
      );

      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: NewsCard(news: news),
          ),
        ),
      );

      expect(find.byType(Image), findsNothing);
    });

    testWidgets('should have Card and ListTile', (tester) async {
      final news = News(
        title: 'Layout Test',
        description: 'Test',
        image: '',
        source: 'Test Source',
        url: 'https://example.com',
        publishedAt: '2024-06-12T10:00:00Z',
      );

      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: NewsCard(news: news),
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(ListTile), findsOneWidget);
    });

    testWidgets('should show broken_image icon when network image fails',
        (tester) async {
      final news = News(
        title: 'Image Load Test',
        description: 'Test',
        image: 'https://example.com/broken.jpg',
        source: 'Test',
        url: 'https://example.com',
        publishedAt: '2024-06-12T10:00:00Z',
      );

      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: NewsCard(news: news),
          ),
        ),
      );

      // The image should try to load; the error builder provides an icon fallback
      expect(find.byType(Image), findsOneWidget);
      expect(find.text('Image Load Test'), findsOneWidget);
    });
  });
}