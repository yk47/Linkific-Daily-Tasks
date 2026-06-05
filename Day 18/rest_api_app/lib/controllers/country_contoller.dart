import 'package:get/get.dart';
import '../models/country.dart';
import '../services/country_service.dart';

class CountryController extends GetxController {
  var countries = <Country>[].obs;
  var isLoading = false.obs;
  var error = ''.obs;

  final service = CountryService();

  void search(String query) async {
    try {
      isLoading(true);
      error('');

      final data = await service.searchCountrySmart(query);

      countries.value = data.map((e) => Country.fromJson(e)).toList();
    } catch (e) {
      error("No country found for '$query'");
      countries.clear();
    } finally {
      isLoading(false);
    }
  }
}
