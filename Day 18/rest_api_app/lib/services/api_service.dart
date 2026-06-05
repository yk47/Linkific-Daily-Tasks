import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  Future<dynamic> get(String url, {Map<String, dynamic>? query}) async {
    Uri uri = Uri.parse(url);

    if (query != null) {
      uri = uri.replace(
        queryParameters: query.map((k, v) => MapEntry(k, v.toString())),
      );
    }

    final response = await http.get(uri);

    print("URL: $uri");
    print("Status: ${response.statusCode}");
    print(response.body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("API Error");
  }
}
