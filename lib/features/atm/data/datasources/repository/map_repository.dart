import 'package:logger/logger.dart';
import 'package:monide/core/network/error_handler.dart';
import 'package:monide/domain/entities/atm.dart';
import 'package:monide/domain/entities/money_trends.dart';
import 'package:monide/domain/entities/search_result.dart';
import 'package:monide/features/atm/data/datasources/map_datasource.dart';

class MapRepository {
  final MapDataSource mapDataSource;
  final Logger _logger = Logger();

  MapRepository(this.mapDataSource);

  Future<String> getLocation(double latitude, double longitude) async {
    try {
      return await mapDataSource.getLocation(latitude, longitude);
    } on ApiException catch (e) {
      _logger.e('ApiException in getLocation: ${e.message} (Code: ${e.statusCode})');
      throw ApiException(message: e.message, statusCode: e.statusCode);
    } catch (e, stackTrace) {
      _logger.e('Unexpected failure in getLocation: $e\n$stackTrace');
      throw ApiException(message: 'Unexpected error: $e');
    }
  }

  Future<List<ATM>> findNearestAtms(double latitude, double longitude) async {
    try {
      return await mapDataSource.findNearestAtms(latitude, longitude);
    } on ApiException catch (e) {
      _logger.e('ApiException in findNearestAtms: ${e.message} (Code: ${e.statusCode})');
      throw ApiException(message: e.message, statusCode: e.statusCode);
    } catch (e, stackTrace) {
      _logger.e('Unexpected failure in findNearestAtms: $e\n$stackTrace');
      throw ApiException(message: 'Unexpected error: $e');
    }
  }

  Future<List<SearchResult>> searchForAtm(String query) async {
    try {
      return await mapDataSource.searchForAtm(query);
    } on ApiException catch (e) {
      _logger.e('ApiException in searchForAtm: ${e.message} (Code: ${e.statusCode})');
      throw ApiException(message: e.message, statusCode: e.statusCode);
    } catch (e, stackTrace) {
      _logger.e('Unexpected failure in searchForAtm: $e\n$stackTrace');
      throw ApiException(message: 'Unexpected error: $e');
    }
  }

  Future<List<MoneyTrends>> getMoneyTrends() async {
    try {
      return await mapDataSource.getMoneyTrends();
    } on ApiException catch (e) {
      _logger.e('ApiException in getMoneyTrends: ${e.message} (Code: ${e.statusCode})');
      throw ApiException(message: e.message, statusCode: e.statusCode);
    } catch (e, stackTrace) {
      _logger.e('Unexpected failure in getMoneyTrends: $e\n$stackTrace');
      throw ApiException(message: 'Unexpected error: $e');
    }
  }
}