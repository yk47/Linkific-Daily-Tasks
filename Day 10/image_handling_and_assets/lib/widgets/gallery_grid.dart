import 'package:flutter/material.dart';

import '../models/gallery_entry.dart';

class GalleryGrid extends StatelessWidget {
  const GalleryGrid({
    super.key,
    required this.entries,
    required this.onTapEntry,
  });

  final List<GalleryEntry> entries;
  final ValueChanged<GalleryEntry> onTapEntry;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const Text(
        'No images available yet. Pick an image to build the grid.',
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: entries.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (BuildContext context, int index) {
        final GalleryEntry entry = entries[index];
        return InkWell(
          onTap: () => onTapEntry(entry),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image(image: entry.provider, fit: BoxFit.cover),
          ),
        );
      },
    );
  }
}
