class News {
  final String title;
  final String description;
  final String image;
  final String source;
  final String url;
  final String publishedAt;

  News({
    required this.title,
    required this.description,
    required this.image,
    required this.source,
    required this.url,
    required this.publishedAt,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['urlToImage'] ?? '',
      source: json['source']?['name'] ?? '',
      url: json['url'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
    );
  }
}
