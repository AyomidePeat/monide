import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:monide/constants/colors.dart';
import 'package:monide/features/login_screen.dart';
import 'package:monide/services/map.api.dart';
import '../services/firebase_auth.dart';
import '../widgets/custom_button.dart';
import 'home_screen.dart';

final locationProvider = Provider((ref) => mapApiProvider);

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SignUpScreenConsumerState();
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
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
                            hintStyle: const TextStyle(color: Colors.grey),
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
                    const SizedBox(height: 15),
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
                    const SizedBox(height: 15),
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
