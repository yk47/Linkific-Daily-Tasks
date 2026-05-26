import 'package:flutter/material.dart';

class ImageViewerPage extends StatelessWidget {
  const ImageViewerPage({
    super.key,
    required this.title,
    required this.imageProvider,
  });

  final String title;
  final ImageProvider imageProvider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: InteractiveViewer(
        minScale: 0.8,
        maxScale: 4.0,
        child: Center(child: Image(image: imageProvider)),
      ),
    );
  }
}
