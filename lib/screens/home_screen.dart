import 'package:flutter/material.dart';
import 'package:road_mechanic/constants/colors.dart';
import 'package:road_mechanic/constants/screens.dart';
import 'package:road_mechanic/screens/login_screen.dart';
import 'package:road_mechanic/widgets/custom_container.dart';

import '../widgets/menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var now = DateTime.now();
  String _getGreeting(int hour) {
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var greeting = _getGreeting(now.hour);
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
              Text('$greeting John Doe', style: TextStyle(fontSize: 13)),
              Container(
                  width: size.width * 0.2,
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
                        'Akure',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      )
                    ],
                  )),
            ],
          ),
          iconTheme: const IconThemeData(color: Colors.white)),
      body: SingleChildScrollView(physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                    hintText: 'Search for ATM',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 32, 68, 97), width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(20)))),
                onSubmitted: (value) {},
              ),
              SizedBox(height: 10),
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 180,
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 32, 68, 97),
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
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ))),
                                    SizedBox(
                                        height: 30,
                                        width: 100,
                                        child: CustomButton(
                                            text: 'Find ATM', onPressed: () {}))
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
                      left: size.width * 0.40,
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      mainAxisExtent: 115,
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
                              color: Color.fromARGB(255, 29, 78, 117),
                              fontWeight: FontWeight.bold))),
                ],
              ),
              Image.network('https://www.ubagroup.com/wp-content/uploads/2018/09/UBA-logo-6.gif')
            ],
          ),
        ),
      ),
    );
  }
}
