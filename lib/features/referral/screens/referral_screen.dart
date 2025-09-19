import 'package:flutter/material.dart';
import 'package:monide/core/constants/colors.dart';


class ReferalScreen extends StatelessWidget {
  const ReferalScreen({super.key});

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
                    icon:
                        const Icon(Icons.arrow_back_ios, color: Colors.white)),
                const Text(
                  'Refer A Friend',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ],
            )),

            body:Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                   Image.asset('images/reff.png', ), 
                   const Text("Referral feature Not Available Yet",style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),)
                  ],
                ),
              ),
            )
    );
  }
}