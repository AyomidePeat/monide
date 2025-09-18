import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monide/core/network/api_client.dart';
import 'package:monide/core/network/network_info.dart';
import 'package:monide/features/atm/data/datasources/map_datasource.dart';
import 'package:monide/features/auth/data/datasources/auth_data_source.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:monide/features/auth/data/datasources/firebase_data_source.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient( baseUrl: 'https://us1.locationiq.com/v1/');
});

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfo(Connectivity());
});
final locationIqApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: 'https://us1.locationiq.com/v1');
});

final gnewsApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: 'https://gnews.io/api/v4');
});

final mapDataSourceProvider = Provider<MapDataSource>((ref) {
  return MapDataSource(
    ref.read(locationIqApiClientProvider),
    ref.read(networkInfoProvider),
    gnewsApiClient: ref.read(gnewsApiClientProvider),
  );
});

final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  return AuthDataSource(FirebaseAuth.instance);
});


final firestoreProvider = Provider<FirestoreDataSource>((ref) {
  return FirestoreDataSource();
});