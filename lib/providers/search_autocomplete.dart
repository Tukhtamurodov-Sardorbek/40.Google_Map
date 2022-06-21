import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_map_integration/models/autocomplete_model.dart';

final placeResultsProvider =
    ChangeNotifierProvider<PlaceResults>((ref) => PlaceResults());
final searchToggleProvider =
    ChangeNotifierProvider<SearchToggle>((ref) => SearchToggle());

class PlaceResults extends ChangeNotifier {
  // List<AutoCompleteResult> _allAutocompleteResults = [];
  //
  // List<AutoCompleteResult> get searchResults => _allAutocompleteResults;
  //
  // set searchResults(allPlaces) {
  //   _allAutocompleteResults = allPlaces;
  //   notifyListeners();
  // }

  List<AutoCompleteResult> allReturnedResults = [];

  void setResults(List<AutoCompleteResult> allPlaces) {
    print('Came: $allPlaces');
    print('Before: $allReturnedResults');
    allReturnedResults = allPlaces;
    notifyListeners();
    print('After: $allReturnedResults');
  }
}

class SearchToggle extends ChangeNotifier {
  // bool _searchToggle = false;
  //
  // bool get searchToggle => _searchToggle;
  //
  // void toggleSearch() {
  //   _searchToggle = !_searchToggle;
  //   notifyListeners();
  // }
  bool searchToggle = false;

  void toggleSearch() {
    searchToggle = !searchToggle;
    notifyListeners();
  }
}
