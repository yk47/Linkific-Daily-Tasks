import 'api_service.dart';

class CountryService {
  final ApiService api = ApiService();

  Future<List> searchCountrySmart(String query) async {
    try {
      final nameResult = await api.get(
        "https://restcountries.com/v3.1/name/$query",
        query: {},
      );
      return nameResult;
    } catch (_) {
      final capitalResult = await api.get(
        "https://restcountries.com/v3.1/capital/$query",
        query: {},
      );
      return capitalResult;
    }
  }
}
