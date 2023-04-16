import 'package:flutter/material.dart';

class NearbyAtmContainer extends StatelessWidget {
  final String name;
  final String distance;
  final String address;
  final String city;
  final String image;
  const NearbyAtmContainer(
      {super.key,
      required this.name,
      required this.distance,
      required this.address,
      required this.city,
      required this.image
      });

  @override
  Widget build(BuildContext context) {
    return Container(
    
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 32, 68, 97),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Row(
                children: [
                  SizedBox(width: 43, height:43,child: Image.network(image)),
               const   SizedBox(width: 7,),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
                  '$address, $city',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
            ),
            Text(
                  '$distance meters',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
            ),
          ]),
                ],
              ),
        ));
  }
}
