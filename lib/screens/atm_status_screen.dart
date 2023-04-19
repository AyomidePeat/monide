import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:road_mechanic/constants/colors.dart';
import 'package:road_mechanic/model/atm_status_model.dart';
import 'package:road_mechanic/screens/upload_atm_status.dart';
import '../services/cloud_firestore.dart';

class AtmStatusScreen extends ConsumerWidget {
  final atm;
  const AtmStatusScreen({super.key, required this.atm});
 
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final atmStatusRef = ref.watch(databaseProvider);
    return Scaffold(
       // backgroundColor: deepBlue,
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
                CircleAvatar(
                  backgroundImage: NetworkImage(atm.imageUrl),
                ),
                SizedBox(width:7),
                Column(crossAxisAlignment:CrossAxisAlignment.start,
                  children: [
                    Text(
                      atm.name,
                      style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    Text(
                      atm.address,
                      style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          fontSize: 12),
                    ),
                  ],
                ),
              ],
            )),
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
             
                 FutureBuilder<AtmStatus?>(
                  future: atmStatusRef.getAtmStatus('${atm.name + atm.address}'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      if (snapshot.hasData && snapshot.data != null) {
                        AtmStatus atmStatus = snapshot.data!;
                        return Column( crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                'Last Update: ${atmStatus.uploadDate}',
                                style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                  fontStyle: FontStyle.italic,
                                    fontSize: 10),
                              ),
                            ),
                            Text(
                              'Withdrawal Status:  ${atmStatus.withdrawalStatus}',
                              style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17),
                            ),
                            Text(
                              'Transfer Status:  ${atmStatus.transferStatus}',
                              style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17),
                            ),
                            Text(
                              'Airtime Recharge:  ${atmStatus.airtimeStatus}',
                              style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17),
                            ),
                            Text(
                              'Queue:  ${atmStatus.queueStatus}',
                              style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17),
                            ),
                          ],
                        );
                      } else {
                        return Center(
                          child: AlertDialog(
                              content: const Text(
                                'ATM Status not known! \nBe the first to tell us about this ATM🤩',
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
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              UploadStatusScreen(
                                                  nearestAtm: atm),
                                        ));
                                  },
                                  child: const Text('OK'),
                                )
                              ]),
                        );
                      }
                    }
                  },
                )
              ],
            )));
  }
}
