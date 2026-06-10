import 'package:get/get.dart';

import '../models/quote_model.dart';
import '../services/api_service.dart';

class QuoteController extends GetxController {
  final ApiService _apiService = ApiService();

  final RxList<QuoteModel> quotes = <QuoteModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchQuotes();
  }

  Future<void> fetchQuotes() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _apiService.fetchQuotes();

      quotes.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshQuotes() async {
    await fetchQuotes();
  }
}