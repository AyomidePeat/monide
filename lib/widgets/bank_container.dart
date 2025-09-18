import 'package:flutter/material.dart';
import 'package:monide/features/bank_info_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BankContainer extends StatelessWidget {
  final String image;
  final String name;
  final bankInfo;
  const BankContainer(
      {required this.image,
      required this.name,
      required this.bankInfo,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BankInfoScreen(
                      bankInfo: bankInfo,
                      image: image,
                    )));
      },
      child: Container(
          height: 500,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: const Color.fromARGB(255, 32, 68, 97),
          ),
          child: Center(
              child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
  height: 80,
  width: 70,
  child: CachedNetworkImage(
    imageUrl: image,
    fit: BoxFit.cover,
    placeholder: (context, url) => const Center(
      child: CircularProgressIndicator(strokeWidth: 2),
    ),
    errorWidget: (context, url, error) => const Icon(Icons.error),
  ),
),
                      Text(name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                          ))
                    ],
                  )))),
    );
  }
}
