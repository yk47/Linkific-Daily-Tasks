import 'package:get/get.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';

class WeatherController extends GetxController {
  var weather = Rxn<Weather>();
  var isLoading = false.obs;
  var error = ''.obs;

  final WeatherService service;

  WeatherController({WeatherService? service})
      : service = service ?? WeatherService();

  Future<void> fetchWeather(String city) async {
    if (city.trim().isEmpty) return;

    try {
      isLoading(true);
      error('');

      final data = await service.fetchWeather(city);

      weather.value = Weather.fromJson(data);
    } catch (e) {
      weather.value = null;
      error.value = "City not found";
    } finally {
      isLoading(false);
    }
  }
}
