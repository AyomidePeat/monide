import 'package:flutter/material.dart';

class MoneyTrendsWidget extends StatelessWidget {
  final String title;
  final String image;
  final String description;
  final String source;
  const MoneyTrendsWidget(
      {super.key,
      required this.title,
      required this.image,
      required this.description,
      required this.source});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(5),
        width: double.infinity,
        height: 90,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 32, 68, 97),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            CircleAvatar(radius: 30, backgroundImage: NetworkImage(image)),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
             SizedBox(                   width: MediaQuery.of(context).size.width * 0.6,
            
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
               
              ],
            ),
          ],
        ));
  }
}
