import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:road_mechanic/constants/bank_details.dart';
import 'package:road_mechanic/screens/search_results_screen.dart';

import '../services/map.api.dart';

final atmLocationProvider = Provider((ref) => mapApiProvider);

class SearchFieldWidget extends ConsumerStatefulWidget {
  final TextEditingController controller;
  const SearchFieldWidget({required this.controller, super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchFieldWidgetState();
}

class _SearchFieldWidgetState extends ConsumerState<SearchFieldWidget> {
  var searchResults;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final atmLocationRef = ref.watch(mapApiProvider);
    searchForAtms(String query) async {
      setState(() {
        query = widget.controller.text;
        isLoading = true;
      });
      final foundAtm = await atmLocationRef.searchForAtm(query, bankLogos);
      setState(() {
        searchResults = foundAtm;
        isLoading = false;
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
      decoration:  InputDecoration(
          contentPadding: const EdgeInsets.all(8),
          prefixIcon:isLoading?const Text('Searching for',style: TextStyle(color:Colors.white)):const Icon(Icons.search, color: Colors.white),

          hintText: 'Search for ATM',
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontFamily: 'Poppins',
          ),
          enabledBorder: const OutlineInputBorder(
              borderSide:
                  BorderSide(color: Color.fromARGB(255, 32, 68, 97), width: 2),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(20)))),
      onSubmitted: searchForAtms,
    );
  }
}
