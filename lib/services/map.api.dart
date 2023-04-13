import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final mapApiProvider = Provider<MapApi>((ref) => MapApi());

class MapApi {
  //Ahvb0AUgVX1oJcPT8jLvclhoFr_c6eY87PY2CxpdPEVcYm9hYxCmJYzCjJJcC85b

// Define the Bing Maps API key and endpoint URLs
  final String apiKey =
      'Ahvb0AUgVX1oJcPT8jLvclhoFr_c6eY87PY2CxpdPEVcYm9hYxCmJYzCjJJcC85b';
  final String routesEndpoint = 'https://dev.virtualearth.net/REST/v1/Routes';
  final String imageryEndpoint =
      'https://dev.virtualearth.net/REST/v1/Imagery/Map';

// Define a function to retrieve route information from Bing Maps API
  Future getBusinessInfo() async {
    // Prepare the request URL with query parameters
    String start = 'Ile Oluji, Ondo';
    String end = 'Akure Ondo';
    String requestUrl = '$routesEndpoint?wp.0=$start&wp.1=$end&key=$apiKey';

    try {
      // Make the HTTP GET request
      http.Response response = await http.get(Uri.parse(requestUrl));

      // Check the response status code
      if (response.statusCode == 200) {
        // Parse the response body
        Map<String, dynamic> data = jsonDecode(response.body);

        // Extract the route information from the response
        // Example: Extracting the duration and distance of the route
        String duration = data['resourceSets'][0]['resources'][0]
                ['travelDurationTraffic']
            .toString();
        String distance = data['resourceSets'][0]['resources'][0]
                ['travelDistance']
            .toString();

        print('Duration: $duration seconds');
        print('Distance: $distance meters');
      } else {
        // Handle the API error response
        print('API request failed with status code ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that may occur during the request
      print('Error occurred during API request: $e');
    }
  }

// Define a function to retrieve imagery from Bing Maps API
  Future fetchImagery() async {
    // Prepare the request URL with query parameters
    String center = '47.6062,-122.3321';
    String zoomLevel = '15';
    String requestUrl =
        '$imageryEndpoint?mapArea=$center&zoomLevel=$zoomLevel&key=$apiKey';

    try {
      // Make the HTTP GET request
      http.Response response = await http.get(Uri.parse(requestUrl));

      // Check the response status code
      if (response.statusCode == 200) {
        // Parse the response body
        Map<String, dynamic> data = jsonDecode(response.body);

        // Extract the image URL from the response
        // Example: Extracting the URL of the map imagery
        String imageUrl = data['resourceSets'][0]['resources'][0]['imageUrl'];
         print('Image URL: $imageUrl');
        return NetworkImage(imageUrl);
      
      } else {
        // Handle the API error response
        print('API request failed with status code ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that may occur during the request
      print('Error occurred during API request: $e');
    }
  }
}
