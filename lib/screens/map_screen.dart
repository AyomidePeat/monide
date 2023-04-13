import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:road_mechanic/services/map.api.dart';

final mapProvider = FutureProvider((ref) async {
  final map = ref.watch(mapApiProvider);
  return map.fetchImagery();
});
final mapImageProvider = FutureProvider((ref) async {
  final map = ref.watch(mapApiProvider);
  return map.getBusinessInfo();
});

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapRef = ref.watch(mapProvider);
    final mapImageRef = ref.watch(mapImageProvider);
    return Scaffold(
        body: ListView(
      children: [
        mapRef.when(data: (data) {
          return Text(data.toString());
        }, error: (error, _) {
          return Text(error.toString());
        }, loading: () {
          return const Center(child: CircularProgressIndicator());
        }),
        mapImageRef.when(data: (data) {
          return data;
        }, error: (error, _) {
          return Text(error.toString());
        }, loading: () {
          return const Center(child: CircularProgressIndicator());
        }),

      ],
    ));
  }
}
