import 'package:flutter/material.dart';
import 'package:google_map_integration/models/autocomplete_model.dart';

class PlaceResults extends ChangeNotifier {
  List<AutoCompleteResult> _allAutocompleteResults = [];

  List<AutoCompleteResult> get searchResults => _allAutocompleteResults;

  set searchResults(List<AutoCompleteResult> allPlaces) {
    _allAutocompleteResults = allPlaces;
    notifyListeners();
  }
}

class SearchToggle extends ChangeNotifier {
  bool _searchToggle = false;

  bool get searchToggle => _searchToggle;

  void toggleSearch() {
    _searchToggle = !_searchToggle;
    notifyListeners();
  }
}

class FromToggle extends ChangeNotifier {
  bool _fromToggle = false;

  bool get fromToggle => _fromToggle;

  void toggleFrom() {
    _fromToggle = !_fromToggle;
    notifyListeners();
  }
}

class ToToggle extends ChangeNotifier {
  bool _toToggle = false;

  bool get toToggle => _toToggle;

  void toggleTo() {
    _toToggle = !_toToggle;
    notifyListeners();
  }
}
