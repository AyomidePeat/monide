import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:monide/constants/colors.dart';
import 'package:monide/model/atm_status_model.dart';
import 'package:monide/features/home_screen.dart';
import 'package:monide/widgets/custom_button.dart';

import '../services/cloud_firestore.dart';

class UploadStatusScreen extends ConsumerStatefulWidget {
  final nearestAtm;
  const UploadStatusScreen({super.key, required this.nearestAtm});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UploadStatusScreenConsumerState();
}

class _UploadStatusScreenConsumerState
    extends ConsumerState<UploadStatusScreen> {
  final cloudFirestore = CloudFirestore();
  String currentDate =
      DateFormat('hh:mm a, EEEE,  MMMM dd, yyyy').format(DateTime.now());
  String withdrawalOption = 'Dispensing';
  String transferOption = 'Not Sure';
  String airtimeOption = 'Not Sure';
  bool isLoading = false;
  int sliderValue = 0;
  List labels = ['No Queue', 'Short', 'A bit Long', 'Very Long'];
  String label = 'No Queue';
  Color? color;
  String action = 'Upload';
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
                  'Tell us about this ATM',
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
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.network(widget.nearestAtm.imageUrl),
                Text(
                  widget.nearestAtm.name,
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                Text(
                  widget.nearestAtm.address,
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          width: 200,
                          child: Text(
                            'Is this ATM dispensing?',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                        ),
                        DropdownButton<String>(
                          dropdownColor: const Color.fromARGB(255, 32, 68, 97),
                          value: withdrawalOption,
                          onChanged: (newValue) {
                            setState(() {
                              withdrawalOption = newValue!;
                            });
                          },
                          items: <String>['Dispensing', 'Not Dispensing']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          width: 200,
                          child: Text(
                            'Cash Transfer?',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                        ),
                        DropdownButton<String>(
                          dropdownColor: const Color.fromARGB(255, 32, 68, 97),
                          value: transferOption,
                          onChanged: (newValue) {
                            setState(() {
                              transferOption = newValue!;
                            });
                          },
                          items: <String>[
                            'Working Perfectly',
                            'No Network',
                            'Not Sure'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          width: 200,
                          child: Text(
                            'Airtime Recharge?',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                        ),
                        DropdownButton<String>(
                          dropdownColor: const Color.fromARGB(255, 32, 68, 97),
                          value: airtimeOption,
                          onChanged: (newValue) {
                            setState(() {
                              airtimeOption = newValue!;
                            });
                          },
                          items: <String>[
                            'Working Perfectly',
                            'No Network',
                            'Not Sure'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'How long is the queue?',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    const SizedBox(height: 5),
                    Slider(
                      activeColor: color,
                      label: label,
                      divisions: 3,
                      min: 0,
                      max: 9,
                      value: sliderValue.toDouble(),
                      onChanged: (value) {
                        setState(() {
                          sliderValue = value.round();
                          if (sliderValue < 2) {
                            label = labels[0];
                            color = Colors.greenAccent;
                          }
                          if (sliderValue >= 2 && sliderValue < 5) {
                            label = labels[1];
                            color = const Color.fromARGB(255, 172, 219, 84);
                          }
                          if (sliderValue >= 5 && sliderValue < 8) {
                            label = labels[2];
                            color = const Color.fromARGB(255, 212, 137, 31);
                          }
                          if (sliderValue >= 8) {
                            label = labels[3];
                            color = Colors.red;
                          }
                        });
                      },
                    )
                  ],
                ),
                CustomButton(
                    onPressed: () async {
                      var atmStatus;
                      setState(() {
                        isLoading = true;
                        atmStatus = AtmStatus(
                            name: widget.nearestAtm.name,
                            address: widget.nearestAtm.address,
                            withdrawalStatus: withdrawalOption,
                            transferStatus: transferOption,
                            queueStatus: label,
                            airtimeStatus: airtimeOption,
                            uploadDate: currentDate);
                      });
                      await cloudFirestore.uploadAtmStatusToDatabase(
                          atm: atmStatus,
                          uid:
                              '${widget.nearestAtm.name + widget.nearestAtm.address}');
                      setState(() {
                        isLoading = false;
                        action = 'Uploaded';
                      });
                      AlertDialog(
                          content: const Text(
                            'Thank you for helping out. Youre the best👍',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 32, 68, 97),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            )
                          ]);
                    },
                    color: const Color.fromARGB(255, 32, 68, 97),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            child: AspectRatio(
                                aspectRatio: 1 / 1,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                )))
                        : Text(
                            action,
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ))
              ]),
        ));
  }
}
