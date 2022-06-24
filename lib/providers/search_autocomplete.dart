import 'package:flutter/material.dart';
import 'package:google_map_integration/models/autocomplete_model.dart';

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
    allReturnedResults = allPlaces;
    notifyListeners();
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

class FromToggle extends ChangeNotifier {
  bool fromToggle = false;

  void toggleFrom() {
    fromToggle = !fromToggle;
    notifyListeners();
  }
}

class ToToggle extends ChangeNotifier {
  bool toToggle = false;

  void toggleTo() {
    toToggle = !toToggle;
    notifyListeners();
  }
}
