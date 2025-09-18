
import 'package:monide/model/nearest_atm_model.dart';

abstract class MapRepository {
  Future<String> getLocation(double latitude, double longitude);
  Future<List<ATM>> findNearestAtm(double latitude, double longitude, List<String> imageUrls);
  Future<List<SearchResult>> searchAtm(String query, List<String> imageUrls);
}