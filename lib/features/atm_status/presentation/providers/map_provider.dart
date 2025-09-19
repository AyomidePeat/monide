import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:monide/core/network/error_handler.dart';
import 'package:monide/core/providers/app_providers.dart';
import 'package:monide/domain/entities/atm.dart';
import 'package:monide/domain/entities/money_trends.dart';
import 'package:monide/domain/entities/search_result.dart';
import 'package:monide/features/atm_status/data/datasources/repository/map_repository.dart';



final mapRepositoryProvider = Provider<MapRepository>((ref) {
  return MapRepository(ref.read(mapDataSourceProvider));
});

final mapProvider = StateNotifierProvider<MapNotifier, MapState>((ref) {
  return MapNotifier(ref.read(mapRepositoryProvider));
});

class MapNotifier extends StateNotifier<MapState> {
  final MapRepository mapRepository;
  final Logger _logger = Logger();

  MapNotifier(this.mapRepository) : super(const MapState());

  Future<void> fetchNearbyAtms(double latitude, double longitude) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      _logger.i('Fetching nearby ATMs for lat: $latitude, lon: $longitude');
      final atms = await mapRepository.findNearestAtms(latitude, longitude);
      state = state.copyWith(isLoading: false, atms: atms);
    } on ApiException catch (e) {
      _logger.e('ApiException fetching nearby ATMs: ${e.message} (Code: ${e.statusCode})');
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e, stackTrace) {
      _logger.e('Unexpected error fetching nearby ATMs: $e\n$stackTrace');
      state = state.copyWith(isLoading: false, error: 'Unexpected error: $e');
    }
  }

  Future<void> getLocation(double latitude, double longitude) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      _logger.i('Fetching location for lat: $latitude, lon: $longitude');
      final location = await mapRepository.getLocation(latitude, longitude);
      state = state.copyWith(isLoading: false, location: location);
    } on ApiException catch (e) {
      _logger.e('ApiException fetching location: ${e.message} (Code: ${e.statusCode})');
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e, stackTrace) {
      _logger.e('Unexpected error fetching location: $e\n$stackTrace');
      state = state.copyWith(isLoading: false, error: 'Unexpected error: $e');
    }
  }

  Future<void> searchForAtm(String query) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      _logger.i('Searching for ATM with query: $query');
      final results = await mapRepository.searchForAtm(query);
      state = state.copyWith(isLoading: false, searchResults: results);
    } on ApiException catch (e) {
      _logger.e('ApiException searching for ATM: ${e.message} (Code: ${e.statusCode})');
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e, stackTrace) {
      _logger.e('Unexpected error searching for ATM: $e\n$stackTrace');
      state = state.copyWith(isLoading: false, error: 'Unexpected error: $e');
    }
  }

  Future<void> fetchMoneyTrends({bool isRefresh = false}) async {
    state = state.copyWith(isLoading: true, error: null, moneyTrends: isRefresh ? [] : state.moneyTrends);
    try {
      _logger.i('Fetching money trends${isRefresh ? ' (refresh)' : ''}');
      final trends = await mapRepository.getMoneyTrends();
      state = state.copyWith(isLoading: false, moneyTrends: trends);
    } on ApiException catch (e) {
      _logger.e('ApiException fetching money trends: ${e.message} (Code: ${e.statusCode})');
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e, stackTrace) {
      _logger.e('Unexpected error fetching money trends: $e\n$stackTrace');
      state = state.copyWith(isLoading: false, error: 'Unexpected error: $e');
    }
  }
}
class MapState extends Equatable {
  final bool isLoading;
  final String? error;
  final List<ATM> atms;
  final String? location;
  final List<SearchResult> searchResults;
  final List<MoneyTrends> moneyTrends;

  const MapState({
    this.isLoading = false,
    this.error,
    this.atms = const [],
    this.location,
    this.searchResults = const [],
    this.moneyTrends = const [],
  });

  MapState copyWith({
    bool? isLoading,
    String? error,
    List<ATM>? atms,
    String? location,
    List<SearchResult>? searchResults,
    List<MoneyTrends>? moneyTrends,
  }) {
    return MapState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      atms: atms ?? this.atms,
      location: location ?? this.location,
      searchResults: searchResults ?? this.searchResults,
      moneyTrends: moneyTrends ?? this.moneyTrends,
    );
  }

  @override
  List<Object?> get props => [isLoading, error, atms, location, searchResults, moneyTrends];
}