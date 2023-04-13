import 'package:flutter/material.dart';

class MoneyTrendsWidget extends StatelessWidget {
  final String title;
  final String image;
   final String description;
  final String author;
  const MoneyTrendsWidget(
      {super.key,
      required this.title,
      required this.image,
     required this.description,
     required this.author
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin:  EdgeInsets.all(10),
        width: double.infinity,
        height: 90,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 32, 68, 97),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CircleAvatar(radius: 50,
              backgroundImage: NetworkImage(image)),
            SizedBox(width: 200,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'By $author',overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
