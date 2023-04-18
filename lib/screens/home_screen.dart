import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:road_mechanic/constants/bank_details.dart';
import 'package:road_mechanic/constants/colors.dart';
import 'package:road_mechanic/screens/found_atm.dart';
import 'package:road_mechanic/services/map.api.dart';
import 'package:road_mechanic/widgets/custom_container.dart';
import '../model/user_model.dart';
import '../services/cloud_firestore.dart';
import '../widgets/custom_button.dart';
import '../widgets/menu.dart';
import '../widgets/search_field_widget.dart';
import 'check_atm_screen.dart';
import 'contact_bank.dart';
import 'money_trend__list_screen.dart';

final atmLocationProvider = Provider((ref) => mapApiProvider);
final userNameProvider = Provider((ref) => databaseProvider);

class HomeScreen extends ConsumerStatefulWidget {
  final  location;
  final user;
  const HomeScreen({super.key,  this.location, this.user});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HomeScreenConsumerState();
}

class _HomeScreenConsumerState extends ConsumerState<HomeScreen> {
  var now = DateTime.now();
  // String _getGreeting(int hour) {
  //   if (hour < 12) {
  //     return 'Good Morning';
  //   } else if (hour < 17) {
  //     return 'Good Afternoon';
  //   } else {
  //     return 'Good Evening';
  //   }
  // }
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  late var user;
  @override
  void dispose() {
    searchController.dispose();
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
  var nearestAtm;

  @override
  Widget build(BuildContext context) {
    List screens = [
      CheckAtmScreen(nearestAtm: nearestAtm),
      const ContactBankScreen(),
      const MoneyTrendsScreen(),
      const ContactBankScreen(),
      const MoneyTrendsScreen(),
      const ContactBankScreen(),
    ];
    final atmLocationRef = ref.watch(mapApiProvider);
    final userDetailsRef = ref.watch(databaseProvider);
    final size = MediaQuery.of(context).size;

    // var greeting = _getGreeting(now.hour);
    @override
    @override
    void initState() {
      super.initState();
      setState(() {
        user = widget.user;
      });
    }

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
              MenuWidget(),
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
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ));
                      } else {
                        // User details not found
                        return const Text('User details not found');
                      }
                    }
                  }),
              //const Text('Hello John Doe', style: TextStyle(fontSize: 13)),
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
              SearchFieldWidget(controller: searchController),
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
                                        onPressed: () async {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          Position position = await Geolocator
                                              .getCurrentPosition(
                                                  desiredAccuracy:
                                                      LocationAccuracy.high);
                                          final nearByAtm = await atmLocationRef
                                              .findNearestAtm(
                                                  position.latitude,
                                                  position.longitude,
                                                  bankLogos);
                                          setState(() {
                                            nearestAtm = nearByAtm;
                                            isLoading = false;
                                          });
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
                constraints: BoxConstraints(maxHeight: size.height * 0.35),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Near you',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold)),
                  TextButton(
                      onPressed: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => ));
                      },
                      child: const Text("See all",
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Color.fromARGB(255, 29, 78, 117),
                              fontWeight: FontWeight.bold))),
                ],
              ),
              // Image.network(
              //     'https://www.ubagroup.com/wp-content/uploads/2018/09/UBA-logo-6.gif')
            ],
          ),
        ),
      ),
    );
  }
}
