import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:monide/core/network/error_handler.dart';

class ApiClient {
  final Dio _dio;
  final String baseUrl;
  final Logger _logger = Logger();

  ApiClient({required this.baseUrl}) : _dio = Dio(BaseOptions(baseUrl: baseUrl));

  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    try {
      final response = await _dio.get(
        endpoint,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            ...?headers,
          },
        ),
      );
      _logger.i('API Response: ${response.data} (URL: $baseUrl$endpoint)');
      return response.data;
    } on DioException catch (e) {
      throw ErrorHandler.handleError(e);
    } catch (e, stackTrace) {
      _logger.e('Unexpected error in ApiClient: $e\n$stackTrace');
      throw ApiException(message: 'Unexpected error: $e');
    }
  }
}