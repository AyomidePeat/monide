import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:monide/constants/bank_details.dart';
import 'package:monide/constants/colors.dart';
import 'package:monide/screens/found_atm.dart';
import 'package:monide/screens/support_screen.dart';
import 'package:monide/services/map.api.dart';
import 'package:monide/widgets/custom_container.dart';
import '../model/user_model.dart';
import '../services/cloud_firestore.dart';
import '../widgets/custom_button.dart';
import '../widgets/search_field_widget.dart';
import 'check_atm_screen.dart';
import 'contact_bank.dart';
import 'money_trend__list_screen.dart';
import 'dart:math' show pi;

final atmLocationProvider = Provider((ref) => mapApiProvider);
final userNameProvider = Provider((ref) => databaseProvider);

class HomeScreen extends ConsumerStatefulWidget {
  final location;
  final user;
  final nearbyAtm;
  const HomeScreen({super.key, this.location, this.user, this.nearbyAtm});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HomeScreenConsumerState();
}

class _HomeScreenConsumerState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _controller;
  var now = DateTime.now();

  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  bool isSearchLoding = false;
  late var user;
  @override
  void dispose() {
    searchController.dispose();
    _controller.dispose();
    super.dispose();
  }

  List images = [
    'images/loading.png',
    'images/atm.png',
    'images/customer-support.png',
    'images/business.png',
    'images/support.png',
    'images/refer.png',
  ];
  List<String> actions = [
    'Check ATM status',
    'Upload ATM status',
    'Help/Contact Us',
    'Money Trends',
    'Contact A Bank',
    'Refer a friend'
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    setState(() {
      user = widget.user;
    });
    _animation = Tween<double>(begin: 0.0, end: 2 * pi).animate(_controller);
    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    var nearestAtm;
    final atmLocationRef = ref.watch(mapApiProvider);
    final userDetailsRef = ref.watch(databaseProvider);
    final size = MediaQuery.of(context).size;

    positionGetter() async {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final nearByAtm = await atmLocationRef.findNearestAtm(
          position.latitude, position.longitude, bankLogos);
      setState(() {
        nearestAtm = nearByAtm;
        isLoading = false;
      });
    }

    List screens = [
      CheckAtmScreen(nearestAtm: widget.nearbyAtm),
      FoundATMScreen(nearbyAtm: widget.nearbyAtm),
      const SupportScreen(),
      const MoneyTrendsScreen(),
      const MoneyTrendsScreen(),
      const ContactBankScreen(),
    ];
    return Scaffold(
      backgroundColor: deepBlue,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FutureBuilder<UserDetails?>(
                  future: userDetailsRef.getUserDetails(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text('Hello',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ));
                    } else {
                      if (snapshot.hasData && snapshot.data != null) {
                        // User details retrieved successfully
                        UserDetails userDetails = snapshot.data!;
                        String username = userDetails.name; // Get the username
                        return Text('Hello $username',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ));
                      } else {
                        return const Text('User details not found');
                      }
                    }
                  }),
              Container(
                  padding: const EdgeInsets.only(right: 5),
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 32, 68, 97),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        color: Colors.white,
                      ),
                      Text(
                        widget.location,
                        overflow: TextOverflow.fade,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'Poppins',
                        ),
                      )
                    ],
                  )),
            ],
          ),
          iconTheme: const IconThemeData(color: Colors.white)),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SearchFieldWidget(
                    controller: searchController,
                    isLoading: isSearchLoding,
                  ),
                  if (isSearchLoding)
                    searchAnimation(
                        controller: _controller, animation: _animation),
                ],
              ),
              const SizedBox(height: 10),
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 180,
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 32, 68, 97),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        width: size.width * 0.45,
                                        child: const Text(
                                            'Find out if ATMs around you are working',
                                            overflow: TextOverflow.fade,
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ))),
                                    SizedBox(
                                      height: 30,
                                      width: 100,
                                      child: CustomButton(
                                        color: deepBlue,
                                        child: isLoading
                                            ? const SizedBox(
                                                height: 20,
                                                child: AspectRatio(
                                                    aspectRatio: 1 / 1,
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: Colors.white,
                                                    )))
                                            : const Text('Find ATM'),
                                        onPressed: () {
                                          positionGetter();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      FoundATMScreen(
                                                          nearbyAtm:
                                                              nearestAtm)));
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                      left: size.width > 393
                          ? size.width * 0.70
                          : size.width > 925
                              ? size.width * 0.80
                              : size.width * 0.4,
                      height: 170,
                      bottom: 10,
                      child: Align(
                          alignment: Alignment.topRight,
                          child: Image.asset(
                            'images/phoneman.png',
                          )))
                ],
              ),
              const SizedBox(height: 10),
              const Text('Perform an Action',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: size.height),
                child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      mainAxisExtent: size.height > 830 ? 170 : 115,
                    ),
                    itemCount: 6,
                    itemBuilder: (BuildContext context, int index) {
                      return CustomContainer(
                        screen: screens[index],
                        image: images[index],
                        text: actions[index],
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class searchAnimation extends StatelessWidget {
  const searchAnimation({
    super.key,
    required AnimationController controller,
    required Animation<double> animation,
  })  : _controller = controller,
        _animation = animation;

  final AnimationController _controller;
  final Animation<double> _animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()..rotateY(_animation.value),
          child: const Text('...',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        );
      },
    );
  }
}
