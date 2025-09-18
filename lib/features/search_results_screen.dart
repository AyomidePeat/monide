import 'package:flutter/material.dart';
import 'package:monide/core/constants/colors.dart';
import 'package:monide/domain/entities/search_result.dart';
import '../model/nearest_atm_model.dart';
import '../widgets/search_result_container.dart';

class SearchResultsScreen extends StatelessWidget {
  final searchResults;
  const SearchResultsScreen({super.key, required this.searchResults});

  @override
  Widget build(BuildContext context) {
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
                    icon:
                        const Icon(Icons.arrow_back_ios, color: Colors.white)),
                const Text(
                  'Found ATMs',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ],
            )),
        body: ListView.builder(
          itemCount: searchResults.length,
          itemBuilder: (BuildContext context, int index) {
            SearchResult atm = searchResults[index];
            if (searchResults.isNotEmpty) {
              return ListTile(
                  title: SearchResultContainer(
                name: atm.name,
                image: atm.imageUrl,
              ));
            } else {
              return const Center(
                child: Text(
                  'No ATM found near you',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              );
            }
          },
        ));
  }
}
