import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:road_mechanic/model/nearest_atm_model.dart';
import 'package:road_mechanic/screens/atm_status_screen.dart';
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
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(//backgroundColor: deepBlue,
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
                        const SizedBox(width:20),
                const Text(
                  'Check ATM status',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ],
            )),
          body:
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SearchFieldWidget(controller: searchController),
                      ),
                      const SizedBox(height: 10), 
                      Flexible(
                        child: ListView.builder(
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
                        ),
                        onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>AtmStatusScreen(atm: atm))),);
                      
                        }),
                      )]),
                  )
      ),
    );  }
            }