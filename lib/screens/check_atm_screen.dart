import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:road_mechanic/model/nearest_atm_model.dart';
import 'package:road_mechanic/services/map.api.dart';
import 'package:road_mechanic/widgets/search_field_widget.dart';
import '../constants/colors.dart';
import '../widgets/nearbyatm_container.dart';


final atmLocationProvider = FutureProvider((ref) => mapApiProvider);

class CheckAtmScreen extends ConsumerStatefulWidget {
  final nearestAtm;
  const CheckAtmScreen({required this.nearestAtm, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CheckAtmScreenState();
}

class _CheckAtmScreenState extends ConsumerState<CheckAtmScreen> {
  final searchController = TextEditingController();
  Position? position;
  bool isFetchingData =
      false; // Add a flag to track if data is currently being fetched
  var nearestAtm;
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getPosition();
  }

  getPosition() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: deepBlue,
        body:
                Column(children: [
                  SearchFieldWidget(controller: searchController),
                  const SizedBox(height: 20), 
                  ListView.builder(
            itemCount: widget.nearestAtm.length,
            itemBuilder: (BuildContext context, int index) {
              ATM atm = widget.nearestAtm[index];
             return ListTile(
                      title: NearbyAtmContainer(
                    name: atm.name,
                    distance: atm.distance.toString(),
                    address: atm.address,
                    city: atm.city,
                    image: atm.imageUrl,
                  ));

  })])
  );  }
            }