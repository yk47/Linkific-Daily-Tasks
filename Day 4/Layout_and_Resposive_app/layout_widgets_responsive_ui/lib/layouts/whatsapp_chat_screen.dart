import 'package:flutter/material.dart';

class WhatsAppChatScreen extends StatelessWidget {
  const WhatsAppChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
        ),
        // Chat list
        Expanded(
          child: ListView.builder(
            itemCount: 50,
            itemBuilder: (context, index) {
              final isOutgoing = index % 2 == 0;
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 6.0,
                ),
                child: Row(
                  mainAxisAlignment: isOutgoing
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    if (!isOutgoing)
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.deepPurple,
                        child: Text(
                          'U${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    if (!isOutgoing) const SizedBox(width: 8),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isOutgoing
                              ? Colors.deepPurple[100]
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: isOutgoing
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Message ${index + 1}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${(index + 1) * 2}:${(index + 1) * 3}${index % 2 == 0 ? 'AM' : 'PM'}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (isOutgoing) const SizedBox(width: 8),
                    if (isOutgoing)
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.blue,
                        child: Text(
                          'Me',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
        // Message input area
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () {},
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: Colors.deepPurple,
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
