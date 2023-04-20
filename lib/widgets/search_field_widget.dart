import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../constants/bank_details.dart';
import '../screens/search_results_screen.dart';
import '../services/map.api.dart';

final atmLocationProvider = Provider((ref) => mapApiProvider);

class SearchFieldWidget extends ConsumerStatefulWidget {
 
  final TextEditingController controller;

   SearchFieldWidget({required this.controller, super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchFieldWidgetState();
}

class _SearchFieldWidgetState extends ConsumerState<SearchFieldWidget> {
  var searchResults;

  @override
  Widget build(BuildContext context) {
    final atmLocationRef = ref.watch(mapApiProvider);
    searchForAtms(String query) async {
      setState(() {
        query = widget.controller.text;
        
      });
      final foundAtm = await atmLocationRef.searchForAtm(query, bankLogos);
      setState(() {
        searchResults = foundAtm;
       
      });
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                SearchResultsScreen(searchResults: searchResults),
          ));
    }

    return TextField(
      style: const TextStyle(color: Colors.white),
      controller: widget.controller,
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
      onSubmitted: searchForAtms,
    );
  }
}
