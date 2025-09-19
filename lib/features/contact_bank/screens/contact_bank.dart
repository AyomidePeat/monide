import 'package:flutter/material.dart';
import 'package:monide/core/constants/bank_details.dart';
import 'package:monide/widgets/bank_container.dart';

import '../../../core/constants/colors.dart';

class ContactBankScreen extends StatelessWidget {
  const ContactBankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: deepBlue,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white))),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              mainAxisExtent: 150,
            ),
            itemCount: bankLogos.length,
            itemBuilder: (BuildContext context, int index) {
              return BankContainer(
                name: bankNames[index],
                image: bankLogos[index],
                bankInfo: bankContact[index],
              );
            }),
      ),
    );
  }
}
