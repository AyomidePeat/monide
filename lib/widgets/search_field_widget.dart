import 'package:flutter/material.dart';
class SearchFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  const SearchFieldWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(8),
          prefixIcon: Icon(Icons.search, color: Colors.white),
          hintText: 'Search for ATM',
          hintStyle: TextStyle(
            color: Colors.grey,
            fontFamily: 'Poppins',
          ),
          enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Color.fromARGB(255, 32, 68, 97), width: 2),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(20)))),
      onSubmitted: (value) {},
    );
  }
}