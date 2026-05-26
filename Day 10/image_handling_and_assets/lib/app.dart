import 'package:flutter/material.dart';

import 'screens/image_showcase_page.dart';

class ImageHandlingApp extends StatelessWidget {
  const ImageHandlingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Image Handling And Assets',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const ImageShowcasePage(),
    );
  }
}
