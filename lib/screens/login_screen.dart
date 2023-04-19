import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:road_mechanic/constants/bank_details.dart';
import 'package:road_mechanic/screens/home_screen.dart';
import 'package:road_mechanic/screens/signup_screen.dart';
import 'package:road_mechanic/services/firebase_auth.dart';
import 'package:road_mechanic/services/map.api.dart';
import '../constants/colors.dart';
import '../widgets/custom_button.dart';

final locationProvider = Provider((ref) => mapApiProvider);

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LoginScreenConsumerState();
}

class _LoginScreenConsumerState extends ConsumerState<LoginScreen> {
  FirebaseAuthentication authenticationHandler = FirebaseAuthentication();
  // GoogleSignIn googleSignIn = GoogleSignIn();
  bool isLoading = false;
  bool googlesignIn = false;
  var nearestAtm;
  var actualLocation = 'Unknown';
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    fontFamily: 'Poppins',
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
                      hintText: 'Email',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: deepBlue)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white))),
                ),
              ),
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
                        hintText: 'Password',
                        hintStyle:
                            const TextStyle(color: Colors.grey, fontSize: 12),
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
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  height: 35,
                  width: double.infinity,
                  child: CustomButton(color: deepBlue,
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            child: AspectRatio(
                                aspectRatio: 1 / 1,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                )))
                        : const Text('Log in'),
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      Future.delayed(const Duration(seconds: 1));
                      String output = await authenticationHandler.signIn(
                          email: emailController.text,
                          password: passwordController.text);
                      if (output == 'Success') {
                        Position position = await Geolocator.getCurrentPosition(
                            desiredAccuracy:
                                LocationAccuracy.bestForNavigation);
                        final bingsMapApi = locationRef;
                        final defLocation = await bingsMapApi.getLocation(
                            position.latitude, position.longitude);
                        final nearByAtm = await locationRef.findNearestAtm(
                            position.latitude, position.longitude, bankLogos);
                        setState(() {
                          actualLocation = defLocation;
                          nearestAtm = nearByAtm;
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                    location: actualLocation,
                                    nearbyAtm: nearByAtm)));
                      } else {
                        setState(() {
                          isLoading = false;
                        });
                        const Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: AspectRatio(
                            aspectRatio: 1 / 1,
                            child:
                                CircularProgressIndicator(color: Colors.white),
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: deepBlue,
                            content: Text(output,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 16))));
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
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
              const SizedBox(height: 7),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: size.width / 3,
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        googlesignIn = true;
                      });
                      var user = await authenticationHandler.signInWithGoogle();
                      setState(() {
                        googlesignIn = false;
                      });
                      if (user != null) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                      location: actualLocation,
                                      user: user,
                                    )));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        side: const BorderSide(color: deepBlue, width: 2),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: googlesignIn
                        ? const SizedBox(
                            height: 20,
                            child: AspectRatio(
                                aspectRatio: 1 / 1,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                )))
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  height: 20,
                                  child: Image.asset('images/google_logo.png')),
                              const SizedBox(width: 7),
                              const Text("Google"),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
