import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:rest_api_app/services/api_service.dart';

import 'api_service_test.mocks.dart';

void main() {
  group('ApiService', () {
    late ApiService apiService;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      apiService = ApiService(client: mockClient);
    });

    test('get should return decoded JSON on success', () async {
      final expectedJson = {'key': 'value'};

      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response(jsonEncode(expectedJson), 200),
      );

      final result = await apiService.get(
        'https://api.example.com/data',
        query: {'param': 'test'},
      );

      expect(result, expectedJson);
    });

    test('get should throw Exception on non-200 status', () async {
      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response('Not Found', 404),
      );

      expect(
        () => apiService.get('https://api.example.com/data'),
        throwsA(isA<Exception>()),
      );
    });

    test('get should handle missing query parameters', () async {
      final expectedJson = {'data': 'test'};

      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response(jsonEncode(expectedJson), 200),
      );

      final result = await apiService.get('https://api.example.com/data');

      expect(result, expectedJson);
    });
  });
}