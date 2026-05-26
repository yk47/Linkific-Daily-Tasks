import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'image_frame.dart';

class CachedNetworkImageCard extends StatelessWidget {
  const CachedNetworkImageCard({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
    required this.fit,
  });

  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return ImageFrame(
      width: width,
      height: height,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: fit,
        fadeInDuration: const Duration(milliseconds: 450),
        placeholder: (BuildContext context, String url) => Container(
          width: width,
          height: height,
          color: Colors.grey.shade200,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(),
        ),
        errorWidget: (BuildContext context, String url, Object error) =>
            Container(
              width: width,
              height: height,
              color: Colors.grey.shade300,
              alignment: Alignment.center,
              child: const Icon(Icons.broken_image_outlined, size: 34),
            ),
      ),
    );
  }
}
