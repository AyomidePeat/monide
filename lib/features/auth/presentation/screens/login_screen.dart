import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monide/core/constants/colors.dart';
import 'package:monide/features/auth/presentation/providers/auth_provider.dart';
import 'package:monide/features/auth/presentation/providers/location_provider.dart';
import 'package:monide/features/home_screen.dart';
import 'package:monide/widgets/custom_button.dart';
import 'package:permission_handler/permission_handler.dart';

class LoginScreen extends ConsumerStatefulWidget {
 const LoginScreen({super.key});

 @override
 ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
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
 final authState = ref.watch(authStateProvider);
 final authNotifier = ref.read(authStateProvider.notifier);
 final locationState = ref.watch(locationStateProvider);
 final locationNotifier = ref.read(locationStateProvider.notifier);
 final size = MediaQuery.of(context).size;

 return Scaffold(
 backgroundColor: blackColor,
 body: SafeArea(
 top: false,
 child: SingleChildScrollView(
 child: Column(
 mainAxisAlignment: MainAxisAlignment.spaceAround,
 children: [
 SizedBox(
 height: size.height / 2.5,
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
 borderSide: BorderSide(color: deepBlue),
 ),
 focusedBorder: UnderlineInputBorder(
 borderSide: BorderSide(color: Colors.white),
 ),
 ),
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
 border: const OutlineInputBorder(borderSide: BorderSide.none),
 hintText: 'Password',
 hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
 suffixIcon: IconButton(
 onPressed: () => setState(() => obscure = !obscure),
 icon: Icon(
 obscure ? Icons.visibility : Icons.visibility_off,
 color: Colors.white,
 size: 15,
 ),
 ),
 enabledBorder: const UnderlineInputBorder(
 borderSide: BorderSide(color: deepBlue),
 ),
 focusedBorder: const UnderlineInputBorder(
 borderSide: BorderSide(color: Colors.white),
 ),
 ),
 ),
 ),
 ),
 const SizedBox(height: 15),
 Padding(
 padding: const EdgeInsets.all(20.0),
 child: SizedBox(
 height: 35,
 width: double.infinity,
 child: CustomButton(
 color: deepBlue,
 child: authState.isLoading || locationState.isLoading
 ? const SizedBox(
 height: 20,
 child: CircularProgressIndicator(
 strokeWidth: 2,
 color: Colors.white,
 ),
 )
 : const Text('Log in'),
 onPressed: () async {
 await authNotifier.signIn(
 emailController.text,
 passwordController.text,
 );
 if (authState.user != null) {
 if (kIsWeb) {
 await locationNotifier.fetchLocationAndAtms();
 if (locationState.location != null &&
 locationState.nearestAtms != null) {
 Navigator.pushReplacement(
 context,
 MaterialPageRoute(
 builder: (context) => HomeScreen(
 location: locationState.location!,
 nearestAtms: locationState.nearestAtms!,
 ),
 ),
 );
 }
 } else {
 final permission = await Permission.location.request();
 if (permission.isGranted) {
 await locationNotifier.fetchLocationAndAtms();
 if (locationState.location != null &&
 locationState.nearestAtms != null) {
 Navigator.pushReplacement(
 context,
 MaterialPageRoute(
 builder: (context) => HomeScreen(
 location: locationState.location!,
 nearestAtms: locationState.nearestAtms!,
 ),
 ),
 );
 }
 } else {
 openAppSettings();
 }
 }
 }
 if (authState.error != null) {
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
 if (locationState.error != null) {
 ScaffoldMessenger.of(context).showSnackBar(
 SnackBar(
 backgroundColor: deepBlue,
 content: Text(
 locationState.error!,
 textAlign : TextAlign.center,
 style: const TextStyle(fontSize: 16),
 ),
 ),
 );
 }
 },
 ),
 ),
 ),
 const SizedBox(height: 15),
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
 Navigator.pushReplacement(
 context,
 MaterialPageRoute(builder: (context) => const SignUpScreen()),
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