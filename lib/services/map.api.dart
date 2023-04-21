import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:monide/model/nearest_atm_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../constants/bank_details.dart';

final mapApiProvider = Provider<MapApi>((ref) => MapApi());

class MapApi {
  Future<String> getLocation(double latitude, double longitude) async {
    String addressString = '';
    try {
      String apiKey = dotenv.env['MAP_API_KEY'] ?? '';
      String endpoint =
          'https://us1.locationiq.com/v1/reverse.php?key=$apiKey&lat=$latitude&lon=$longitude&format=json';
      final response = await http.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        String street = jsonData['address']['road'] ?? '';
        String city = jsonData['address']['city'] ?? '';
        String state = jsonData['address']['state'] ?? '';

        addressString = '$street $city, $state';
      }
    } catch (e) {
      addressString = 'Unknown';
      return addressString ;
    }
    return addressString;
  }

  Future<List<ATM>> findNearestAtm(
      double latitude, double longitude, List<String> imageUrls) async {
    List<ATM> banks = [];
    try {
      String apiKey = dotenv.env['MAP_API_KEY'] ?? '';
      String endpoint =
          'https://us1.locationiq.com/v1/nearby.php?key=$apiKey&lat=$latitude&lon=$longitude&tag=bank&radius=5000&format=json';
      final response = await http.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<Map<String, dynamic>> bankDataList =
            (jsonData as List).cast<Map<String, dynamic>>();
        banks = bankDataList
            .map((bankData) => ATM(
                name: bankData['name'] ?? '',
                distance: bankData['distance']?.toDouble() ?? 0.0,
                address: bankData['address'] != null
                    ? bankData['address']['road'] ?? ''
                    : '',
                city: bankData['address'] != null
                    ? bankData['address']['city'] ?? ''
                    : '',
                imageUrl: getBankImage(bankData['name'], imageUrls)))
            .toList();
      }
    } catch (e) {
      print('Failed to fetch nearest banks. Exception: $e');
    }
    return banks;
  }

  String getBankImage(String bankName, List<String> imageUrls) {
    String? bankImage = bankNametoImage[bankName] ??
        'https://www.idfcfirstbank.com/content/dam/idfcfirstbank/images/blog/finance/what-is-atm-717x404.jpg';
    return bankImage ?? '';
  }

  Future<dynamic> searchForAtm(String query, List<String> imageUrls) async {
    List<SearchResult> foundBanks = [];
    String apiKey = dotenv.env['MAP_API_KEY'] ?? '';
    String url =
        'https://us1.locationiq.com/v1/search.php?key=$apiKey&q=$query&countrycodes=ng&&format=json&addressdetails=1';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<Map<String, dynamic>> bankDataList =
          (jsonData as List).cast<Map<String, dynamic>>();
      foundBanks = bankDataList
          .map((bankData) => SearchResult(
              name: bankData['display_name'] ?? '',
              imageUrl: getBankImage(bankData['display_name'], imageUrls)))
          .toList();
    } else {
      throw Exception('Failed to search for location');
    }

    return foundBanks;
  }
}
