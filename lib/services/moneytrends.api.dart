import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monide/model/money_trends_model.dart';
import 'package:http/http.dart' as http;

final moneyApiProvider = Provider<MoneyTrendsApi>((ref) => MoneyTrendsApi());

class MoneyTrendsApi {
  Future<List<MoneyTrends>> getMoneyTrends() async {
    try {
      String apiKey = dotenv.env['NEWS_API_KEY'] ?? '';
      
      String endpoint =
          'https://gnews.io/api/v4/top-headlines?category=business&lang=en&token=$apiKey';

      final response = await http.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<Map<String, dynamic>> newsDataList =
            (jsonData['articles'] as List).cast<Map<String, dynamic>>();
        List<MoneyTrends> newsList = newsDataList
            .map((newsData) => MoneyTrends.fromJson(newsData))
            .toList();
        return newsList;
      } else {
        print('Failed to fetch news. Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Failed to fetch news. Exception: $e');
      return [];
    }
  }
}
