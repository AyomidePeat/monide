import 'package:flutter/material.dart';
import 'package:road_mechanic/constants/colors.dart';

class CustomContainer extends StatelessWidget {
  final String text;
  final String image;
  final screen;
  const CustomContainer(
      {required this.screen, required this.text, required this.image, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => screen));
      },
      child: Container(
          height: 500,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color.fromARGB(255, 32, 68, 97),
          ),
          child: Center(
              child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: 30,
                    child: Image.asset(
                      image,
                      color: Color.fromARGB(255, 135, 202, 236),
                    )),
                const SizedBox(
                  height: 15,
                ),
                Text(text,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.fade,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,  fontFamily: 'Poppins',
                      color: Colors.white,
                    )),
              ],
            ),
          ))),
    );
  }
}
