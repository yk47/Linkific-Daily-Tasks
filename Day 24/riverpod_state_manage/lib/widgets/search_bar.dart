import 'package:flutter/material.dart';
import 'package:movie_app/core/theme/app_theme.dart';


class MovieSearchBar extends StatelessWidget {
  final Function(String) onChanged;

  const MovieSearchBar({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
      child: TextField(
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        decoration: const InputDecoration(
          hintText: 'Search movies, series...',
          prefixIcon: Icon(Icons.search_rounded, size: 20),
        ),
        onChanged: onChanged,
      ),
    );
  }
}