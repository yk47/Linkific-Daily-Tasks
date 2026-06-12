import 'api_service.dart';

class NewsService {
  final ApiService api;

  NewsService({ApiService? api}) : api = api ?? ApiService();

  final String apiKey = "f09d268748fd93bff212dea7b24c290e";

  Future<dynamic> fetchTopHeadlines() async {
    return await api.get(
      "https://gnews.io/api/v4/top-headlines",
      query: {
        "category": "general",
        "lang": "en",
        "country": "in",
        "max": "20",
        "apikey": apiKey,
      },
    );
  }

  Future<dynamic> searchNews(String query) async {
    return await api.get(
      "https://gnews.io/api/v4/search",
      query: {
        "q": query,
        "lang": "en",
        "country": "in",
        "max": "20",
        "apikey": apiKey,
      },
    );
  }
}
