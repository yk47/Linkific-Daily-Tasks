import 'package:get/get.dart';

import '../models/quote_model.dart';
import '../services/hive_service.dart';

class FavoriteController extends GetxController {

  final HiveService _hiveService = HiveService();


  final RxList<Map<String, dynamic>> favorites =
      <Map<String, dynamic>>[].obs;



  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }


void loadFavorites() {

  final data = _hiveService.getQuotes();

  if (Get.isRegistered<FavoriteController>()) {
    Future.microtask(() {
      favorites.assignAll(data);
    });
  }

}


  bool isFavorite(QuoteModel quote) {

    return favorites.any(
      (item) => item['quote'] == quote.quote,
    );

  }




  Future<void> addFavorite(QuoteModel quote) async {


    if (_hiveService.quoteExists(quote.quote)) {

      Get.snackbar(
        'Already Saved',
        'This quote is already in favorites',
      );

      return;
    }



    await _hiveService.saveQuote({

      'id': quote.id,
      'quote': quote.quote,
      'author': quote.author,

    });



    loadFavorites();



    Get.snackbar(
      'Success',
      'Quote added to favorites',
    );

  }





  Future<void> removeFavorite(int index) async {


    await _hiveService.deleteQuote(index);


    loadFavorites();


    Get.snackbar(
      'Removed',
      'Quote removed from favorites',
    );

  }





  Future<void> removeFavoriteByQuote(
      QuoteModel quote) async {


    final index = favorites.indexWhere(
      (item) => item['quote'] == quote.quote,
    );



    if(index != -1){

      await _hiveService.deleteQuote(index);


      loadFavorites();


      Get.snackbar(
        'Removed',
        'Quote removed from favorites',
      );

    }

  }

}