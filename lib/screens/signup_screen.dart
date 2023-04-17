import 'package:flutter/material.dart';
import 'package:road_mechanic/constants/colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: blackColor,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height:size.height/2.5, width:size.width,
                child: Image.asset(fit:BoxFit.fill ,
                  'images/Subtract.png',
                  width: double.infinity,
                  scale: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontFamily: "Rubik",
                          fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      controller: nameController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(borderSide: BorderSide.none),
                          labelText: 'Full Name',
                          labelStyle: TextStyle(color: Colors.white, fontSize: 15),
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
                          border: OutlineInputBorder(borderSide: BorderSide.none),
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.white, fontSize: 15),
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
                          border: OutlineInputBorder(borderSide: BorderSide.none),
                          labelText: 'Phone Number',
                          labelStyle: TextStyle(color: Colors.white, fontSize: 15),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: deepBlue)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white))),
                    ),
                    SizedBox(
                      height: 70,
                      child: TextField(
                        obscureText: obscure,
                        style: const TextStyle(color: Colors.white, fontSize: 15),
                        cursorColor: Colors.white,
                        controller: passwordController,
                        decoration: InputDecoration(
                            border:
                                const OutlineInputBorder(borderSide: BorderSide.none),
                            labelText: 'Password',
                            labelStyle: const TextStyle(color: Colors.white),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscure = !obscure;
                                  });
                                },
                                icon: Icon(
                                    obscure ? Icons.visibility : Icons.visibility_off,
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
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text("Sign Up"),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: deepBlue,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () {},
                            child: const Text("Do you have an account?",
                                style: TextStyle(  fontFamily: 'Poppins',color: Colors.white))),
                        TextButton(
                            onPressed: () {},
                            child: const Text("Login",
                                style: TextStyle(color: deepBlue))),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 170,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text(" Google"),
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
                            child: Text(" Facebook"),
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
