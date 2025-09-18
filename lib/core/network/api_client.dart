import 'package:http/http.dart' as http;
import 'dart:convert';
import '../error/exceptions.dart';

class ApiClient {
  final http.Client client;
  final String baseUrl;

  ApiClient({required this.client, required this.baseUrl});

  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      ).timeout(const Duration(seconds: 10));

      return _handleResponse(response);
    } catch (e) {
      throw ServerException('Network error: $e');
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw ServerException('Server error: ${response.statusCode}');
    }
  }
}