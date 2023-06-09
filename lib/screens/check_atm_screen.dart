import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:monide/constants/colors.dart';
import 'package:monide/model/nearest_atm_model.dart';
import 'package:monide/screens/atm_status_screen.dart';
import 'package:monide/services/map.api.dart';
import 'package:monide/widgets/search_field_widget.dart';
import '../widgets/nearbyatm_container.dart';
import 'dart:math' show pi;

final atmLocationProvider = FutureProvider((ref) => mapApiProvider);

class CheckAtmScreen extends ConsumerStatefulWidget {
  final nearestAtm;
  const CheckAtmScreen({required this.nearestAtm, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CheckAtmScreenState();
}

class _CheckAtmScreenState extends ConsumerState<CheckAtmScreen>
    with SingleTickerProviderStateMixin {
  final searchController = TextEditingController();
  late Animation<double> _animation;
  late AnimationController _controller;
  Position? position;
  bool isFetchingData =
      false; // Add a flag to track if data is currently being fetched
  var nearestAtm;
  @override
  void dispose() {
    searchController.dispose();
    _controller.dispose();
    super.dispose();
  }

  var isSearchLoding = false;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween<double>(begin: 0.0, end: 2 * pi).animate(_controller);
    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
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
                      icon: const Icon(Icons.arrow_back_ios,
                          color: Colors.white)),
                  const SizedBox(width: 20),
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
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SearchFieldWidget(
                      controller: searchController,
                    
                    ),
                  
                  ],
                ),
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
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AtmStatusScreen(atm: atm))),
                      );
                    }),
              )
            ]),
          )),
    );
  }
}
