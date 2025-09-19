import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';


class BankInfoScreen extends StatelessWidget {
  final Map bankInfo;
  final String image;
  const BankInfoScreen(
      {required this.bankInfo, required this.image, super.key});

  @override
  Widget build(BuildContext context) {
    final String address = bankInfo['address'].toString();
    final String name = bankInfo['name'].toString();
    final String contact = bankInfo['contact'].toString();

    return Scaffold(
      backgroundColor: deepBlue,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: IconButton(onPressed: ()=>Navigator.pop(context),icon: const Icon(Icons.arrow_back_ios, color:Colors.white))
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            top: 20,
            right: 20,
          ),
          child: Column(
            children: [
              SizedBox(height: 300, child: Image.network(image, fit:BoxFit.contain )),
               const SizedBox(height: 20),
              Text(
                ' ${name.toUpperCase()}', textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'HeadQuarter Address',
                style: TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                  fontSize: 15,  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                textAlign: TextAlign.center,
                address,
                style: const TextStyle(color: Colors.white, fontSize: 13,  fontFamily: 'Poppins',),
              ),
              const SizedBox(height: 10),
              const Text(
                'Email/Phone Number',
                style: TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 10),
              Text(
                textAlign: TextAlign.center,
                contact,
                style: const TextStyle(color: Colors.white,  fontFamily: 'Poppins', fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
