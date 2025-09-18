import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:monide/core/constants/bank_details.dart';
import 'package:monide/core/network/api_client.dart';
import 'package:monide/core/network/error_handler.dart';
import 'package:monide/core/network/network_info.dart';
import 'package:monide/domain/entities/atm.dart';

import 'package:monide/domain/entities/money_trends.dart';
import 'package:monide/domain/entities/search_result.dart';

class MapDataSource {
  final ApiClient locationIqApiClient;
  final ApiClient gnewsApiClient;
  final NetworkInfo networkInfo;
  final Logger _logger = Logger();

  MapDataSource(
    this.locationIqApiClient,
    this.networkInfo, {
    required this.gnewsApiClient,
  });

  Future<String> getLocation(double latitude, double longitude) async {
    if (!await networkInfo.isConnected) {
      _logger.w('No internet connection for getLocation');
      throw ApiException(message: 'No internet connection');
    }

    try {
      String apiKey = dotenv.env['MAP_API_KEY'] ?? '';
      if (apiKey.isEmpty) {
        _logger.e('MAP_API_KEY is missing in .env');
        throw ApiException(message: 'API key is missing');
      }
      final response = await locationIqApiClient.get(
        '/reverse.php?key=$apiKey&lat=$latitude&lon=$longitude&format=json',
      );

      _logger.i('getLocation response: ${response.toString()}');
      final jsonData = response as Map<String, dynamic>;
      if (jsonData['address'] == null) {
        _logger.w('Invalid response: address field is missing');
        throw ApiException(message: 'Invalid response: address field is missing');
      }
      String street = jsonData['address']['road'] as String? ?? 'Unknown Street';
      String city = jsonData['address']['city'] as String? ?? 'Unknown City';
      String state = jsonData['address']['state'] as String? ?? 'Unknown State';
      return '$street, $city, $state';
    } on ApiException catch (e) {
      _logger.e('ApiException in getLocation: ${e.message} (Code: ${e.statusCode})');
      throw ApiException(message: e.message, statusCode: e.statusCode);
    } catch (e, stackTrace) {
      _logger.e('Unexpected error in getLocation: $e\n$stackTrace');
      throw ApiException(message: 'Unexpected error: $e');
    }
  }

  Future<List<ATM>> findNearestAtms(double latitude, double longitude) async {
    if (!await networkInfo.isConnected) {
      _logger.w('No internet connection for findNearestAtms');
      throw ApiException(message: 'No internet connection');
    }

    try {
      String apiKey = dotenv.env['MAP_API_KEY'] ?? '';
      if (apiKey.isEmpty) {
        _logger.e('MAP_API_KEY is missing in .env');
        throw ApiException(message: 'API key is missing');
      }
      final response = await locationIqApiClient.get(
        '/nearby.php?key=$apiKey&lat=$latitude&lon=$longitude&tag=bank&radius=5000&format=json',
      );

      _logger.i('findNearestAtms response: ${response.toString()}');
      final List<dynamic> bankDataList = response as List<dynamic>;
      return bankDataList.map((bankData) {
        final data = bankData as Map<String, dynamic>;
        return ATM(
          name: data['name'] as String? ?? 'Unknown Bank',
          distance: (data['distance'] as num?)?.toDouble() ?? 0.0,
          address: data['address']?['road'] as String? ?? 'Unknown Address',
          city: data['address']?['city'] as String? ?? 'Unknown City',
          imageUrl: _getBankImage(data['name'] as String? ?? 'Unknown Bank'),
        );
      }).toList();
    } on ApiException catch (e) {
      _logger.e('ApiException in findNearestAtms: ${e.message} (Code: ${e.statusCode})');
      throw ApiException(message: e.message, statusCode: e.statusCode);
    } catch (e, stackTrace) {
      _logger.e('Unexpected error in findNearestAtms: $e\n$stackTrace');
      throw ApiException(message: 'Unexpected error: $e');
    }
  }

  Future<List<SearchResult>> searchForAtm(String query) async {
    if (!await networkInfo.isConnected) {
      _logger.w('No internet connection for searchForAtm');
      throw ApiException(message: 'No internet connection');
    }

    try {
      String apiKey = dotenv.env['MAP_API_KEY'] ?? '';
      if (apiKey.isEmpty) {
        _logger.e('MAP_API_KEY is missing in .env');
        throw ApiException(message: 'API key is missing');
      }
      final response = await locationIqApiClient.get(
        '/search.php?key=$apiKey&q=$query&countrycodes=ng&format=json&addressdetails=1',
      );

      _logger.i('searchForAtm response: ${response.toString()}');
      final List<dynamic> bankDataList = response as List<dynamic>;
      return bankDataList.map((bankData) {
        final data = bankData as Map<String, dynamic>;
        return SearchResult(
          name: data['display_name'] as String? ?? 'Unknown Location',
          imageUrl: _getBankImage(data['display_name'] as String? ?? 'Unknown Bank'),
        );
      }).toList();
    } on ApiException catch (e) {
      _logger.e('ApiException in searchForAtm: ${e.message} (Code: ${e.statusCode})');
      throw ApiException(message: e.message, statusCode: e.statusCode);
    } catch (e, stackTrace) {
      _logger.e('Unexpected error in searchForAtm: $e\n$stackTrace');
      throw ApiException(message: 'Unexpected error: $e');
    }
  }

  Future<List<MoneyTrends>> getMoneyTrends() async {
    if (!await networkInfo.isConnected) {
      _logger.w('No internet connection for getMoneyTrends');
      throw ApiException(message: 'No internet connection');
    }

    try {
      String apiKey = dotenv.env['NEWS_API_KEY'] ?? '';
      if (apiKey.isEmpty) {
        _logger.e('NEWS_API_KEY is missing in .env');
        throw ApiException(message: 'News API key is missing');
      }
      final response = await gnewsApiClient.get(
        '/top-headlines?category=business&lang=en&token=$apiKey',
      );

      _logger.i('getMoneyTrends response: ${response.toString()}');
      final jsonData = response as Map<String, dynamic>;
      if (jsonData['articles'] == null) {
        _logger.w('Invalid response: articles field is missing');
        throw ApiException(message: 'Invalid response: articles field is missing');
      }
      final List<dynamic> newsDataList = jsonData['articles'] as List<dynamic>;
      return newsDataList.map((newsData) {
        final data = newsData as Map<String, dynamic>;
        if (data['title'] == null || data['url'] == null) {
          _logger.w('Invalid news data: $data');
          return MoneyTrends(
            title: 'Unknown Title',
            description: 'No description available',
            url: '',
            imageUrl: '',
          );
        }
        return MoneyTrends.fromJson(data);
      }).toList();
    } on ApiException catch (e) {
      _logger.e('ApiException in getMoneyTrends: ${e.message} (Code: ${e.statusCode})');
      throw ApiException(message: e.message, statusCode: e.statusCode);
    } catch (e, stackTrace) {
      _logger.e('Unexpected error in getMoneyTrends: $e\n$stackTrace');
      throw ApiException(message: 'Unexpected error: $e');
    }
  }

  String _getBankImage(String bankName) {
    return bankNameToImage[bankName] ??
        'https://www.idfcfirstbank.com/content/dam/idfcfirstbank/images/blog/finance/what-is-atm-717x404.jpg';
  }
}