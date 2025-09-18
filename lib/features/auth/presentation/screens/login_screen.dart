import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monide/core/constants/colors.dart';
import 'package:monide/features/auth/presentation/providers/auth_provider.dart';
import 'package:monide/features/home_screen.dart';
import 'package:monide/features/auth/presentation/widgets/auth_form_widget.dart';
import 'dart:developer';

import 'package:monide/features/signup_screen.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);

    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    void handleLogin() async {
      await authNotifier.signIn(
        email: emailController.text,
        password: passwordController.text,
      );

      if (authState.isAuthenticated && context.mounted) {
        log('Auth has been authenticated');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      } else if (authState.error != null && context.mounted) {
        log('This is the error ${authState.error}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: deepBlue,
            content: Text(
              authState.error!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: blackColor,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 2.5,
                child: Image.asset(
                  'images/Subtract.png',
                  fit: BoxFit.fill,
                  width: double.infinity,
                ),
              ),
              const Text(
                "Login",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
              AuthFormWidget(
                emailController: emailController,
                passwordController: passwordController,
                isLoading: authState.isLoading,
                onSubmit: handleLogin,
                submitButtonText: 'Log in',
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Forgot Password",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Color.fromARGB(255, 29, 78, 117),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}