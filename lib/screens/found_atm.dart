import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:road_mechanic/constants/colors.dart';
import '../model/nearest_atm_model.dart';
import '../widgets/nearbyatm_container.dart';



class FoundATMScreen extends ConsumerStatefulWidget {
  final nearbyAtm;
  const FoundATMScreen({super.key, required this.nearbyAtm});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FoundATMScreenConsumerState();
}

class _FoundATMScreenConsumerState extends ConsumerState<FoundATMScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: deepBlue,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon:
                        const Icon(Icons.arrow_back_ios, color: Colors.white)),
                const Text(
                  'Found ATMs',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ],
            )),
        body: ListView.builder(
          itemCount: widget.nearbyAtm.length,
          itemBuilder: (BuildContext context, int index) {
            ATM atm = widget.nearbyAtm[index];
            if (widget.nearbyAtm.isNotEmpty) {
              return ListTile(
                  title: NearbyAtmContainer(
                name: atm.name,
                distance: atm.distance.toString(),
                address: atm.address,
                city: atm.city,
                image: atm.imageUrl,
              ));
            } else {
              return const Center(
                  child: Text('No ATM found near you',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)));
            }
          },

      
        ));
  }
}
