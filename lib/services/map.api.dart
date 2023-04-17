import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:road_mechanic/model/nearest_atm_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../constants/bank_details.dart';

final mapApiProvider = Provider<BingsMapApi>((ref) => BingsMapApi());



class BingsMapApi {
 
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
        String country = jsonData['address']['country'] ?? '';
        String postalCode = jsonData['address']['postcode'] ?? '';

        addressString = '$street $city, $state';
      } else {
        print('Failed to reverse geocode. Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to reverse geocode. Exception: $e');
    }
    return addressString;
  }

  Future<List<ATM>> findNearestAtm(double latitude, double longitude, List<String> imageUrls) async {
    List<ATM> banks = [];
    try {
      String apiKey = 'pk.b14dade08dd88dd219fe1653cf88459c';
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
                      imageUrl: getBankImage(bankData['name'], imageUrls)
                ))
            .toList();
      } else {
        print('Failed to fetch nearest banks. Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to fetch nearest banks. Exception: $e');
    }
    return banks;
  }

  String getBankImage(String bankName, List<String> imageUrls) {
    String? bankImage = bankNametoImage[bankName]??'https://www.idfcfirstbank.com/content/dam/idfcfirstbank/images/blog/finance/what-is-atm-717x404.jpg';
    return bankImage??'';
  }

}
//E52jdBOFIaUDBYFqjdZIISmHts9pZqeZ