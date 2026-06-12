import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/news.dart';
import '../screens/news_details_screen.dart';

class NewsCard extends StatelessWidget {
  final News news;

  const NewsCard({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => NewsDetailsScreen(news: news));
      },
      child: Card(
        child: Column(
          children: [
            if (news.image.isNotEmpty)
              Image.network(
                news.image,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 200,
                  color: Colors.black26,
                  child: const Center(
                    child: Icon(Icons.broken_image, color: Colors.white54),
                  ),
                ),
              ),

            ListTile(title: Text(news.title), subtitle: Text(news.source)),
          ],
        ),
      ),
    );
  }
}
