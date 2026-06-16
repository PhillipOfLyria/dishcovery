  // lib/core/network/api_client.dart

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../errors/exceptions.dart';

class ApiClient {
  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> get(String url,
      {Map<String, String>? queryParams}) async {
    try {
      final uri = Uri.parse(url).replace(queryParameters: queryParams);
      final response = await _client
          .get(uri)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }

      throw ApiException(
        message: 'Błąd serwera. Spróbuj ponownie później.',
        statusCode: response.statusCode,
      );
    } on SocketException {
      throw const NoInternetException();
    } on FormatException {
      throw const ApiException(message: 'Nieprawidłowy format danych z API.');
    }
  }
}
