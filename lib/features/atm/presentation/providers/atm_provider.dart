import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monide/core/providers/app_providers.dart';
import 'package:monide/features/atm/data/datasources/repository/map_repository.dart';

import '../../../../domain/entities/atm.dart';


final mapRepositoryProvider = Provider<MapRepository>((ref) {
  return MapRepository(ref.read(mapDataSourceProvider));
});

final atmProvider = StateNotifierProvider<AtmNotifier, AtmState>((ref) {
  return AtmNotifier(ref.read(mapRepositoryProvider));
});

class AtmNotifier extends StateNotifier<AtmState> {
  final MapRepository mapRepository;

  AtmNotifier(this.mapRepository) : super(const AtmState());

  Future<void> fetchNearbyAtms(double latitude, double longitude) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final atms = await mapRepository.findNearestAtms(latitude, longitude);
      state = state.copyWith(isLoading: false, atms: atms);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('Failure: ', ''),
      );
    }
  }

  Future<void> getLocation(double latitude, double longitude) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final location = await mapRepository.getLocation(latitude, longitude);
      state = state.copyWith(isLoading: false, location: location);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('Failure: ', ''),
      );
    }
  }
}


class AtmState extends Equatable {
  final bool isLoading;
  final String? error;
  final List<ATM> atms;
  final String? location;

  const AtmState({
    this.isLoading = false,
    this.error,
    this.atms = const [],
    this.location,
  });

  AtmState copyWith({
    bool? isLoading,
    String? error,
    List<ATM>? atms,
    String? location,
  }) {
    return AtmState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      atms: atms ?? this.atms,
      location: location ?? this.location,
    );
  }

  @override
  List<Object?> get props => [isLoading, error, atms, location];
}