import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final mapApiProvider = Provider<BingsMapApi>((ref) => BingsMapApi());

//Ahvb0AUgVX1oJcPT8jLvclhoFr_c6eY87PY2CxpdPEVcYm9hYxCmJYzCjJJcC85b

class BingsMapApi {
  Future getLocation(latitude, longitude) async {
    final String baseUrl = 'https://dev.virtualearth.net/REST/v1/Locations/';
    final String apiKey =
        'Ahvb0AUgVX1oJcPT8jLvclhoFr_c6eY87PY2CxpdPEVcYm9hYxCmJYzCjJJcC85b'; // Replace with your Bing Maps API key
    // Replace with the longitude value
    final Uri uri = Uri.parse('$baseUrl$latitude,$longitude?key=$apiKey');

    final response = await http.get(uri);
   
      // Parse the response to extract the address information
      // The response is in JSON format, so you can use a JSON decoding library like 'dart:convert'
      final Map<String, dynamic> data = json.decode(response.body);
      final address = data['resourceSets'][0]['resources'][0]['address'];

      // Extract the relevant address components
      final street = address['addressLine']??"";
      final city = address['locality'];
      final state = address['adminDistrict'];
      final country = address['countryRegion'];

      // Print or use the extracted address information as needed
      print('Street: $street');
      print('City: $city');
      print('State: $state');
      print('Country: $country');
      var location = '$street $city, $state';
      return location;
    // } else {
    //   print(
    //       'Failed to retrieve address information. Status code: ${response.statusCode}');
     }
  
}
