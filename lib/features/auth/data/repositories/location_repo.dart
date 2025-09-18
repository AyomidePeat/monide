import 'package:geolocator/geolocator.dart';
import 'package:monide/core/error/exceptions.dart';
import 'package:monide/features/auth/data/models/atm_model.dart';
import 'package:monide/services/map_api.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationRepository {
 final MapApi mapApi;

 LocationRepository({required this.mapApi});

 Future<Position> getCurrentPosition() async {
 try {
 return await Geolocator.getCurrentPosition(
 desiredAccuracy: LocationAccuracy.bestForNavigation,
 );
 } catch (e) {
 throw LocationException('Failed to get current position: $e');
 }
 }

 Future<bool> requestLocationPermission() async {
 try {
 final status = await Permission.location.request();
 if (status.isGranted) {
 return true;
 } else if (status.isDenied || status.isPermanentlyDenied) {
 return false;
 }
 throw LocationException('Unknown permission status');
 } catch (e) {
 throw LocationException('Failed to request location permission: $e');
 }
 }

 Future<String> getLocation(double latitude, double longitude) async {
 try {
 return await mapApi.getLocation(latitude, longitude);
 } catch (e) {
 throw LocationException('Failed to get location: $e');
 }
 }

 Future<List<AtmModel>> findNearestAtm(
 double latitude, double longitude, List<String> bankLogos) async {
 try {
 final atmList = await mapApi.findNearestAtm(latitude, longitude, bankLogos);
 return atmList
 .map((atm) => AtmModel(
 name: atm['name'] ?? '',
 latitude: atm['latitude'] ?? 0.0,
 longitude: atm['longitude'] ?? 0.0,
 status: atm['status'] ?? '',
 ))
 .toList();
 } catch (e) {
 throw LocationException('Failed to find nearest ATMs: $e');
 }
 }
}