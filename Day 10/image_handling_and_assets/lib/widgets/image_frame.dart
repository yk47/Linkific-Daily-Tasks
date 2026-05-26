import 'package:flutter/material.dart';

class ImageFrame extends StatelessWidget {
  const ImageFrame({
    super.key,
    required this.child,
    required this.width,
    required this.height,
  });

  final Widget child;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(width: width, height: height, child: child),
    );
  }
}
