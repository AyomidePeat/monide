import 'package:flutter/material.dart';

class SearchResultContainer extends StatelessWidget {
  final String name;
  final String image;
  const SearchResultContainer(
      {required this.name, super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 32, 68, 97),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              SizedBox(width: 55, height: 55, child: Image.network(image)),
              const SizedBox(
                width: 7,
              ),
              SizedBox( width:size.width*0.7,
                child: Text(
                  name,
                  overflow: TextOverflow.fade,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
