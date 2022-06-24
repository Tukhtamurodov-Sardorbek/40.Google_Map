import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_map_integration/models/autocomplete_model.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class MapService {
  final String key = 'AIzaSyAnEGhiJGO4a4buAXRRAu6IQ85sE8ti3x4';
  final String types = 'geocode';

  Future<List<AutoCompleteResult>> searchPlaces(String searchInput) async {
    final String url =
        'http://mvs.bslmeiyu.com/api/v1/config/place-api-autocomplete?search_text=$searchInput';

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);

    var results = json['predictions'] as List;
    debugPrint('\n*\t Fetched Data (${results.length}) : $results \n');

    return results.map((e) => AutoCompleteResult.fromJson(e)).toList();
  }

  Future<List<Location>> getPlace(String location, BuildContext context) async {
    try {
      List<Location> locations = await locationFromAddress(location);
      debugPrint('\n*\t User\'s location coordinates: (${locations.first.latitude}, ${locations.first.longitude})\n');
      return locations;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 10,
          shape: const StadiumBorder(),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 2500),
          backgroundColor: Colors.grey.shade400.withOpacity(0.9),
          margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          content: const Text(
            'Location not found. Try again!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ),
      );
    }

    return <Location>[];
  }
}
