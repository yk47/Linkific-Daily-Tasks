import 'package:get/get.dart';
import '../models/news.dart';
import '../services/news_service.dart';

class NewsController extends GetxController {
  final NewsService service = NewsService();

  var newsList = <News>[].obs;
  var isLoading = false.obs;
  var error = ''.obs;

  Future<void> fetchTopHeadlines() async {
    try {
      isLoading(true);
      error('');

      final data = await service.fetchTopHeadlines();

      newsList.value = (data['articles'] as List)
          .map((e) => News.fromJson(e))
          .toList();
    } catch (e) {
      error.value = e.toString();
      newsList.clear();
    } finally {
      isLoading(false);
    }
  }

  Future<void> searchNews(String query) async {
    if (query.trim().isEmpty) {
      fetchTopHeadlines();
      return;
    }

    try {
      isLoading(true);
      error('');

      final data = await service.searchNews(query);

      newsList.value = (data['articles'] as List)
          .map((e) => News.fromJson(e))
          .toList();
    } catch (e) {
      error.value = e.toString();
      newsList.clear();
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() {
    fetchTopHeadlines();
    super.onInit();
  }
}
