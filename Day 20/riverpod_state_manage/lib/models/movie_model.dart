class Movie {
  final int id;
  final String title;
  final String type;
  final int year;
  final String poster;
  final String description;

  Movie({
    required this.id,
    required this.title,
    required this.type,
    required this.year,
    required this.poster,
    required this.description,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['name'] ?? '',
      type: json['type'] ?? '',
      year: json['year'] ?? 0,
      poster: json['image_url'] ?? '',
      description: json['plot_overview'] ??
          json['description'] ??
          'No description available.',
    );
  }
}