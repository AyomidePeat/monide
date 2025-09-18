import 'package:flutter/material.dart';
import 'package:monide/core/constants/colors.dart';
import 'package:monide/widgets/custom_button.dart';

class AuthFormWidget extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController? nameController;
  final TextEditingController? phoneController;
  final TextEditingController passwordController;
  final bool isLoading;
  final VoidCallback onSubmit;
  final String submitButtonText;

  const AuthFormWidget({
    super.key,
    required this.emailController,
    this.nameController,
    this.phoneController,
    required this.passwordController,
    required this.isLoading,
    required this.onSubmit,
    required this.submitButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          if (nameController != null)
            TextField(
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              controller: nameController,
              decoration: _inputDecoration('Full Name'),
            ),
          TextField(
            style: const TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            controller: emailController,
            decoration: _inputDecoration('Email'),
          ),
          if (phoneController != null)
            TextField(
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              controller: phoneController,
              decoration: _inputDecoration('Phone Number'),
            ),
          SizedBox(
            height: 70,
            child: TextField(
              obscureText: true,
              style: const TextStyle(color: Colors.white, fontSize: 15),
              cursorColor: Colors.white,
              controller: passwordController,
              decoration: _inputDecoration('Password').copyWith(
                suffixIcon: const Icon(
                  Icons.visibility,
                  color: Colors.white,
                  size: 15,
                ),
              ),
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
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(submitButtonText),
              onPressed: onSubmit,
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hintText) {
    return const InputDecoration(
      border: OutlineInputBorder(borderSide: BorderSide.none),
      hintText: '',
      hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: deepBlue),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
    );
  }
}