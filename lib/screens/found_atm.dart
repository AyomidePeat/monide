import 'package:flutter/material.dart';
import 'package:road_mechanic/constants/colors.dart';

import '../model/nearest_atm_model.dart';
import '../widgets/nearbyatm_container.dart';

class FoundATMScreen extends StatelessWidget {
  final nearbyAtm;
  const FoundATMScreen({super.key, required this.nearbyAtm});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: deepBlue,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: const Text(
              'Found ATMs',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            )),
        body: ListView.builder(
          itemCount: nearbyAtm.length,
          itemBuilder: (BuildContext context, int index) {
            ATM atm = nearbyAtm[index];
        
            return ListTile(
                title: NearbyAtmContainer(
              name: atm.name,
              distance: atm.distance.toString(),
              address: atm.address,
              city: atm.city,
              image: atm.imageUrl,
            ));
          },
        
          //Text(nearbyAtm)
        ));
  }
}
