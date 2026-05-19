import 'package:flutter/material.dart';

class InstagramPostCard extends StatelessWidget {
  const InstagramPostCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
          elevation: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with profile and menu
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey[300],
                          child: Icon(Icons.person, color: Colors.grey[700]),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'user_${index + 1}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Location ${index + 1}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              // Post Image
              Container(
                width: double.infinity,
                height: 300,
                color: Colors.grey[300],
                child: Icon(Icons.image, size: 80, color: Colors.grey[600]),
              ),
              // Like, Comment, Share buttons
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.favorite_border),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.chat_bubble_outline),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.bookmark_border),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              // Likes count
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  '${(index + 1) * 1234} likes',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              // Caption
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'user_${index + 1} ',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text:
                                'Amazing sunset view from today\'s adventure! 🌅✨ #flutter #photography #sunset',
                            style: TextStyle(color: Colors.grey[800]),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'View all ${5 + index} comments',
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${2 + index} hours ago',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
