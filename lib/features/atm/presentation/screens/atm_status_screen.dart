import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monide/core/constants/colors.dart';
import 'package:monide/core/providers/app_providers.dart';
import 'package:monide/domain/entities/atm.dart';
import 'package:monide/domain/entities/atm_status.dart';
import 'package:monide/features/upload_atm_status.dart';

class AtmStatusScreen extends ConsumerWidget {
  final ATM atm;

  const AtmStatusScreen({super.key, required this.atm});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
            CircleAvatar(backgroundImage: NetworkImage(atm.imageUrl)),
            const SizedBox(width: 7),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  atm.name,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  atm.address,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder<AtmStatus?>(
          future: ref.read(firestoreProvider).getAtmStatus('${atm.name + atm.address}'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: AlertDialog(
                    content: const Text(
                      'ATM Status not known! \nBe the first to tell us about this ATM🤩',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    backgroundColor: const Color.fromARGB(255, 32, 68, 97),
                    actions: [
                      TextButton(
                        onPressed: () {
                                                    Navigator.pop(context);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UploadStatusScreen(nearestAtm: atm),
                            ),
                          );
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
            } else {
              final atmStatus = snapshot.data;
              if (atmStatus != null) {
                return ListView(
                  children: [
                    Center(
                      child: Text(
                        'Last Updated: ${atmStatus.uploadDate}',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _StatusCard(
                      icon: Icons.monetization_on,
                      title: 'Withdrawal Status',
                      status: atmStatus.withdrawalStatus,
                    ),
                    _StatusCard(
                      icon: Icons.swap_horiz,
                      title: 'Transfer Status',
                      status: atmStatus.transferStatus,
                    ),
                    _StatusCard(
                      icon: Icons.smartphone,
                      title: 'Airtime Recharge',
                      status: atmStatus.airtimeStatus,
                    ),
                    _StatusCard(
                      icon: Icons.people,
                      title: 'Queue Status',
                      status: atmStatus.queueStatus,
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
                        fontSize: 15,
                      ),
                    ),
                    backgroundColor: const Color.fromARGB(255, 32, 68, 97),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UploadStatusScreen(nearestAtm: atm),
                            ),
                          );
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String status;

  const _StatusCard({
    required this.icon,
    required this.title,
    required this.status,
  });

  Color get _statusColor {
    switch (status) {
      case 'Dispensing':
      case 'Working Perfectly':
      case 'No Queue':
        return const Color(0xFF4CAF50); // Green
      case 'Not Dispensing':
      case 'Very Long':
        return const Color(0xFFF44336); // Red
      case 'No Network':
      case 'Not Sure':
      case 'Short':
      case 'A bit Long':
        return const Color(0xFFFFC107); // Amber
      default:
        return Colors.black;
    }
  }

  String get _getStatusDescription {
    switch (status) {
      case 'Dispensing':
        return 'This ATM is currently dispensing cash and is fully operational.';
      case 'Not Dispensing':
        return 'This ATM is currently not dispensing cash. Please find another ATM.';
      case 'Working Perfectly':
        return 'Service is fully active and processing without delays.';
      case 'No Network':
        return 'Service is currently unavailable due to a network issue.';
      case 'Not Sure':
        return 'The status of this service is currently unknown.';
      case 'No Queue':
        return 'There is currently no one waiting in line. ATM is readily accessible.';
      case 'Short':
        return 'There is a short queue, but the wait time is minimal.';
      case 'A bit Long':
        return 'The queue is a bit long, expect a moderate wait time.';
      case 'Very Long':
        return 'The queue is very long, expect a significant wait time.';
      default:
        return 'Status is unknown.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: deepBlue),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _statusColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            _getStatusDescription,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
