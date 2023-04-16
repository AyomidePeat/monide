import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:road_mechanic/model/money_trends_model.dart';
import 'package:http/http.dart' as http;

final moneyApiProvider = Provider<MoneyTrendsApi>((ref) => MoneyTrendsApi());

class MoneyTrendsApi {
  Future<List<MoneyTrends>> getMoneyTrends() async {
   
    try {
      final response = await http.get(Uri.parse(
          'https://newsapi.org/v2/everything?q=money&apiKey=dc50e9af04af41129611fbc31b554867'));
      final jsonData = jsonDecode(response.body);
      if (jsonData['status'] == "ok") {
        final List<MoneyTrends> trendResults = [];
        if (jsonData['articles'] != null) {
          for (final item in jsonData['articles']!) {
            final trendResult = MoneyTrends.fromJson(item);
            trendResults.add(trendResult);
          }
        }
        
        return trendResults;
      } else {
        throw Exception(
            'Failed to load trendsStatus code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error occurred: $e');
      throw Exception('Failed to load trends. Error: $e');
    }
  }
}
