import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:road_mechanic/screens/home_screen.dart';
import 'package:road_mechanic/screens/signup_screen.dart';
import 'package:road_mechanic/services/map.api.dart';
import 'package:road_mechanic/widgets/navigation_screen.dart';

import '../constants/colors.dart';
final locationProvider = Provider((ref) => mapApiProvider);

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
 ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenConsumerState();
}

class _LoginScreenConsumerState extends ConsumerState<LoginScreen> {
   String actualLocation = 'unknown';
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscure = true;
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     final locationRef = ref.watch(mapApiProvider);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: blackColor,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height / 2.5,
                child: Image.asset(
                  'images/Subtract.png',
                  fit: BoxFit.fill,
                  width: double.infinity,
                  scale: 0.5,
                ),
              ),
              const Text(
                "Login",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontFamily: "Rubik",
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    controller: emailController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        labelText: 'Email',
                        labelStyle:
                            TextStyle(color: Colors.white, fontSize: 15),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: deepBlue)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white))),
                  )),
              Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    height: 70,
                    child: TextField(
                      obscureText: obscure,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                      cursorColor: Colors.white,
                      controller: passwordController,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: Colors.white),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscure = !obscure;
                                });
                              },
                              icon: Icon(
                                  obscure
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white,
                                  size: 15)),
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: deepBlue)),
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white))),
                    ),
                  )),
              Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: CustomButton(text:'Log in', onPressed:  () async {
                // Use the geolocator package to get the user's current location
                Position position = await Geolocator.getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.high);

                // Pass the latitude and longitude to the BingsMapApi to decode the location
                final bingsMapApi = locationRef;
                final defLocation = await bingsMapApi.getLocation(
                    position.latitude, position.longitude);
                
                  setState(() {
                    actualLocation = defLocation;
                  });
                    
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => HomeScreen(location: actualLocation,)));
      },),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {},
                      child: const Text("Forgot Password",
                          style: TextStyle(color: Colors.white))),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()));
                      },
                      child: const Text("Sign Up",
                          style: TextStyle(
                              color: Color.fromARGB(255, 29, 78, 117),
                              fontWeight: FontWeight.bold))),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, top: 40.0, bottom: 15, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 170,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text("Google"),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            side: BorderSide(color: deepBlue, width: 2),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                    SizedBox(
                      width: 170,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text("Facebook"),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            side: BorderSide(color: deepBlue, width: 2),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final onPressed;
  const CustomButton({
    super.key, required this.text, required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed:onPressed,
      child: Text(text),
      style: ElevatedButton.styleFrom(
          backgroundColor: deepBlue,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
    );
  }
}
