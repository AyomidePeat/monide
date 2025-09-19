import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:monide/core/constants/colors.dart';
import 'package:monide/core/constants/text_type_in_effect.dart';
import 'package:monide/features/atm_status/presentation/providers/map_provider.dart';
import 'package:monide/features/atm_status/presentation/screens/check_atm_screen.dart';
import 'package:monide/features/contact_bank/screens/contact_bank.dart';
import 'package:monide/features/atm_status/presentation/screens/found_atm.dart';
import 'package:monide/features/money_trends/screens/money_trend__list_screen.dart';
import 'package:monide/features/referral/screens/referral_screen.dart';
import 'package:monide/features/support/screen.dart/support_screen.dart';
import 'package:monide/widgets/custom_button.dart';
import 'package:monide/widgets/custom_container.dart';
import 'package:monide/widgets/search_field_widget.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenConsumerState();
}

class _HomeScreenConsumerState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late Animation<Offset> animation;
  late AnimationController _controller;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );
    animation = Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchLocationAndAtms();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchLocationAndAtms() async {
    final mapNotifier = ref.read(mapProvider.notifier);
    try {
      final permission = await Permission.location.request();
      if (permission.isGranted) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        await mapNotifier.getLocation(position.latitude, position.longitude);
        await mapNotifier.fetchNearbyAtms(
            position.latitude, position.longitude);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: deepBlue,
              content: Text(
                'Please enable location permissions in settings',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
          await openAppSettings();
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: deepBlue,
            content: Text(
              'Error accessing location: $e',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        );
      }
    }
  }

  List<String> images = [
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
    final mapState = ref.watch(mapProvider);
    final size = MediaQuery.of(context).size;

    List<Widget> screens = [
      CheckAtmScreen(
          nearestAtm: mapState.atms),
      FoundATMScreen(nearbyAtm: mapState.atms),
      const SupportScreen(),
      const MoneyTrendsScreen(),
      const ContactBankScreen(),
      const ReferalScreen(),
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
            const Text(
                    'Hi 👋',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
            
            Container(
              padding: const EdgeInsets.only(right: 5),
              height: 30,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 32, 68, 97),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    color: Colors.white,
                  ),
                  mapState.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          mapState.location ?? 'Unknown',
                          overflow: TextOverflow.fade,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: 'Poppins',
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
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
                    onSubmitted: (query) {
                      if (query.isNotEmpty) {
                        ref.read(mapProvider.notifier).searchForAtm(query);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FoundATMScreen(
                                nearbyAtm: mapState.searchResults),
                          ),
                        );
                      }
                    },
                  ),
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
                            borderRadius: BorderRadius.circular(10),
                          ),
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
                                      child: const TextEffect(
                                        text:
                                            'Find out if ATMs around you are working.',
                                        overflow: TextOverflow.fade,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                      width: 100,
                                      child: CustomButton(
                                        color: deepBlue,
                                        child: mapState.isLoading
                                            ? const SizedBox(
                                                height: 20,
                                                child: AspectRatio(
                                                  aspectRatio: 1 / 1,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              )
                                            : const Text('Find ATM'),
                                        onPressed: () {
                                          if (!mapState.isLoading) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    FoundATMScreen(
                                                  nearbyAtm: mapState.atms,
                                                ),
                                              ),
                                            );
                                          }
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
                        : size.width > 924
                            ? size.width * 0.90
                            : size.width * 0.4,
                    height: 170,
                    bottom: 10,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Image.asset('images/phoneman.png'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Perform an Action',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: size.height * 0.6),
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    mainAxisExtent: size.height > 830 ? 170 : 120,
                  ),
                  itemCount: 6,
                  itemBuilder: (BuildContext context, int index) {
                    return CustomContainer(
                      screen: screens[index],
                      image: images[index],
                      text: actions[index],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
