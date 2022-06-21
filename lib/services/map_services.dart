import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_map_integration/models/autocomplete_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class MapService {
  final String key = 'AIzaSyAnEGhiJGO4a4buAXRRAu6IQ85sE8ti3x4';
  final String types = 'geocode';

  // Future<List<AutoCompleteResult>> searchPlaces(String searchInput) async {
  //   final String url =
  //       'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$searchInput&types=$types&key=$key';
  //
  //   var response = await http.get(Uri.parse(url));
  //
  //   var json = convert.jsonDecode(response.body);
  //
  //   var results = json['predictions'] as List;
  //   print('Fetched Data: ${results.length}');
  //   print('Fetched Data: ${results}');
  //   return results.map((e) => AutoCompleteResult.fromJson(e)).toList();
  // }
  //
  // Future<Map<String, dynamic>> getPlace(String? placeId) async {
  //   final String url =
  //       'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';
  //
  //   var response = await http.get(Uri.parse(url));
  //
  //   var json = convert.jsonDecode(response.body);
  //
  //   var results = json['result'] as Map<String, dynamic>;
  //
  //   return results;
  // }

  Future<List<AutoCompleteResult>> searchPlaces(String searchInput) async {
    final String url = 'http://mvs.bslmeiyu.com/api/v1/config/place-api-autocomplete?search_text=$searchInput';

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);

    var results = json['predictions'] as List;
    print('Fetched Data: ${results.length}');
    print('Fetched Data: ${results}');

    return results.map((e) => AutoCompleteResult.fromJson(e)).toList();
  }

  Future<List<Location>> getPlace(String location, BuildContext context) async {
    try {
      print('****************************');
      List<Location> locations = await locationFromAddress(location);

      print('****************************');
      print('${locations.first.latitude} ${locations.first.longitude}');

      print('****************************');
      print('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
      locations.isNotEmpty ? print('$location : ${locations.length}: ${locations}') : print([]);

      print('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
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

  // a(){
  //   locations = await locationFromAddress(location);
  //
  //   Log.d('${locations.first.latitude} ${locations.first.longitude}');
  //
  //   final mapController = await completer.future;
  //
  //   markers.add(Marker(
  //     markerId: const MarkerId('user_searched_location'),
  //     position: LatLng(
  //       locations.first.latitude,
  //       locations.first.longitude,
  //     ),
  //     icon: BitmapDescriptor.defaultMarker,
  //   ));
  //
  //   await mapController.animateCamera(
  //     CameraUpdate.newCameraPosition(
  //       CameraPosition(
  //         target: LatLng(
  //           locations.first.latitude,
  //           locations.first.longitude,
  //         ),
  //         zoom: 14.6,
  //       ),
  //     ),
  //   );
  // }
}
