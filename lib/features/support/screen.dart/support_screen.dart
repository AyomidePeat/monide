import 'package:flutter/material.dart';
import 'package:monide/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/colors.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode:LaunchMode.externalApplication  );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: deepBlue,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white)),
              const Text(
                'Help/Support',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ],
          )),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset('images/contact.png'),
               const SizedBox(height: 20),
              const Text(
                'Do you need help? Or do have something to tell us?',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
              const SizedBox(height: 30),
              CustomButton(
                onPressed: () {
                  _launchURL('https://wa.me/2349073393147');
                },
                color: const Color.fromARGB(255, 32, 68, 97),
                child: const Text('Contact Us'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
