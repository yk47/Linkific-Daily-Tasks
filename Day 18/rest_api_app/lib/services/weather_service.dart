import 'api_service.dart';

class WeatherService {
  final ApiService api = ApiService();

  final String apiKey = "8bea19c1c781e5902b5fa397b947c3aa";

  Future<dynamic> fetchWeather(String city) async {
    return await api.get(
      "https://api.openweathermap.org/data/2.5/weather",
      query: {"q": city, "appid": apiKey, "units": "metric"},
    );
  }
}
