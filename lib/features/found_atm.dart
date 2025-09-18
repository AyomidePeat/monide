import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monide/core/constants/colors.dart';
import 'package:monide/domain/entities/atm.dart';
import 'package:monide/features/atm/presentation/providers/map_provider.dart';
import 'package:monide/features/atm/presentation/screens/atm_status_screen.dart';
import 'package:monide/widgets/nearbyatm_container.dart';

class FoundATMScreen extends ConsumerWidget {
  final List<dynamic> nearbyAtm;

  const FoundATMScreen({super.key, required this.nearbyAtm});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(mapProvider);

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
            const Text(
              'Found ATMs',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
      body: mapState.isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : mapState.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        mapState.error!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ref.invalidate(mapProvider);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: deepBlue,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : nearbyAtm.isEmpty
                  ? const Center(
                      child: Text(
                        'No ATMs found near you',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: nearbyAtm.length,
                      itemBuilder: (BuildContext context, int index) {
                        final atm = nearbyAtm[index] as ATM;
                        return ListTile(
                          title: NearbyAtmContainer(
                            name: atm.name,
                            distance: atm.distance.toString(),
                            address: atm.address,
                            city: atm.city,
                            image: atm.imageUrl,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AtmStatusScreen(atm: atm),
                              ),
                            );
                          },
                        );
                      },
                    ),
    );
  }
}