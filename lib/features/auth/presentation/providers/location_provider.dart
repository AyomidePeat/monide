import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monide/core/error/exceptions.dart';
import 'package:monide/features/auth/data/repositories/location_repo.dart';
import 'package:monide/services/map.api.dart';

final mapApiProvider = Provider<MapApi>((ref) => MapApi());
final locationRepositoryProvider = Provider<LocationRepository>(
 (ref) => LocationRepository(mapApi: ref.read(mapApiProvider)),
);

class LocationState {
 final bool isLoading;
 final String? error;
 final String? location;
 final List<AtmModel>? nearestAtms;

 LocationState({
 this.isLoading = false,
 this.error,
 this.location,
 this.nearestAtms,
 });

 LocationState copyWith({
 bool? isLoading,
 String? error,
 String? location,
 List<AtmModel>? nearestAtms,
 }) {
 return LocationState(
 isLoading: isLoading ?? this.isLoading,
 error: error,
 location: location ?? this.location,
 nearestAtms: nearestAtms ?? this.nearestAtms,
 );
 }
}

final locationStateProvider =
 StateNotifierProvider<LocationStateNotifier, LocationState>(
 (ref) => LocationStateNotifier(ref),
);

class LocationStateNotifier extends StateNotifier<LocationState> {
 final Ref ref;

 LocationStateNotifier(this.ref) : super(LocationState());

 Future<void> fetchLocationAndAtms() async {
 state = state.copyWith(isLoading: true, error: null);
 try {
 final repo = ref.read(locationRepositoryProvider);
 final permission = await repo.requestLocationPermission();
 if (!permission) {
 state = state.copyWith(
 isLoading: false,
 error: 'Location permission denied',
 );
 return;
 }
 final position = await repo.getCurrentPosition();
 final location = await repo.getLocation(position.latitude, position.longitude);
 final atms = await repo.findNearestAtm(
 position.latitude,
 position.longitude,
 bankLogos,
 );
 state = state.copyWith(
 isLoading: false,
 location: location,
 nearestAtms: atms,
 );
 } on LocationException catch (e) {
 state = state.copyWith(isLoading: false, error: e.message);
 }
 }
}