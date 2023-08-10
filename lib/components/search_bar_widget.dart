import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) filterItems;

  SearchBarWidget({
    required this.searchController,
    required this.filterItems,
  });

  @override
  Widget build(BuildContext context) {
    // ... (build your SearchBar here)
    return  TextField(
        controller: searchController,
        onChanged: filterItems,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderSide: BorderSide(
                  color: Colors.teal, width: 0.0),
            ),
            prefixIcon: Icon(Icons.search),
            hintText: 'Search meal',
            border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.teal))));
  }
}