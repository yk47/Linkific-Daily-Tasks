import 'package:flutter/widgets.dart';

enum GalleryEntrySource { network, local }

class GalleryEntry {
  const GalleryEntry({
    required this.title,
    required this.provider,
    required this.source,
  });

  final String title;
  final ImageProvider provider;
  final GalleryEntrySource source;
}
