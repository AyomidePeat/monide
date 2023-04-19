import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:road_mechanic/constants/colors.dart';
import 'package:road_mechanic/screens/login_screen.dart';
import 'package:road_mechanic/services/map.api.dart';
import '../services/firebase_auth.dart';
import '../widgets/custom_button.dart';
import 'home_screen.dart';

final locationProvider = Provider((ref) => mapApiProvider);
class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
   ConsumerState<ConsumerStatefulWidget> createState() => _SignUpScreenConsumerState();
}

class _SignUpScreenConsumerState extends ConsumerState<SignUpScreen> {
  bool googlesignIn = false;
  var actualLocation = 'Unknown';
  var isLoading = false;
  FirebaseAuthentication authenticationHandler = FirebaseAuthentication();
  bool obscure = true;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    nameController.dispose();
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
                width: size.width,
                child: Image.asset(
                  fit: BoxFit.fill,
                  'images/Subtract.png',
                  width: double.infinity,
                  scale: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      controller: nameController,
                      decoration: const InputDecoration(
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          hintText: 'Full Name',
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 12),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: deepBlue)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white))),
                    ),
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      controller: emailController,
                      decoration: const InputDecoration(
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          hintText: 'Email',
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 12),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: deepBlue)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white))),
                    ),
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      controller: phoneController,
                      decoration: const InputDecoration(
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          hintText: 'Phone Number',
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 12),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: deepBlue)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white))),
                    ),
                    SizedBox(
                      height: 70,
                      child: TextField(
                        obscureText: obscure,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12),
                        cursorColor: Colors.white,
                        controller: passwordController,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                            hintText: 'Password',
                            hintStyle: const TextStyle(color: Colors.white),
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
                    SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          color: deepBlue,
                            child: isLoading
                                ? const SizedBox(
                                    height: 20,
                                    child: AspectRatio(
                                        aspectRatio: 1 / 1,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        )))
                                : const Text('Sign Up'),
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              String output =
                                  await authenticationHandler.signUp(
                                      name: nameController.text,
                                      phoneNumber: phoneController.text,
                                      email: emailController.text,
                                      password: passwordController.text);

                              if (output == "Success") {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()));
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        backgroundColor: deepBlue,
                                        content: Text(
                                            "Account created successfully",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 16))));
                              } else {
                                setState(() {
                                  isLoading = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        backgroundColor: deepBlue,
                                        content: Text(output,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 16))));
                              }
                            })),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () {},
                            child: const Text("Do you have an account?",
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white))),
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()));
                            },
                            child: const Text("Login",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 29, 78, 117),
                                    fontWeight: FontWeight.bold))),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(width: size.width/3,
                        child: ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              googlesignIn = true;
                            });
                            var user = await authenticationHandler
                                .signInWithGoogle();
                            setState(() {
                              googlesignIn = false;
                            });
                            if (user != null) {
                               Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy:
                            LocationAccuracy.bestForNavigation);
                        final bingsMapApi = locationRef;
                        final defLocation = await bingsMapApi.getLocation(
                        position.latitude, position.longitude);

                        setState(() {
                      actualLocation = defLocation;
                        });
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
                              side: const BorderSide(
                                  color: deepBlue, width: 2),
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
                              : Row(  mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  height: 20,
                                  child: Image.asset('images/google_logo.png')),
                             const SizedBox(width:7), const Text("Google"),
                                  ],
                                ),
                        ),
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
