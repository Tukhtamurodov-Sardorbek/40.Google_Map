import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_map_integration/services/color_service.dart';
import 'package:google_map_integration/services/permission_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeProvider extends ChangeNotifier {
  /// Fields
  // * Initial camera position
  final cameraPosition = const CameraPosition(
    target: LatLng(41.3123363, 69.2787079),
    zoom: 14.4746,
  );
  // * To move the camera to the place where is tapped with animation
  late GoogleMapController _googleMapController;

  // * Debounce to throttle async calls during search
  Timer? debounce;
  // * Markers & Polylines
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  int markerIdCounter = 1;
  int polylineIdCounter = 1;
  List<List<double>> fromTo = List.filled(2, [], growable: false);
  bool _searchToggle = false;
  bool _getDirection = false;
  bool _expandZoomInOutLocation = false;
  bool _expandLayer = false; // isExpanded1
  bool _expandSearchNavigation = false; // isExpanded2
  bool _isNormal = true;
  bool _isSatellite = false;
  bool _hasInternet = false;

  final TextEditingController searchController = TextEditingController();
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();

  /// Getters & Setters
  GoogleMapController get googleMapController => _googleMapController;
  set googleMapController(GoogleMapController controller) {
    _googleMapController = controller;
    notifyListeners();
  }

  bool get expandZoomInOutLocation => _expandZoomInOutLocation;
  set expandZoomInOutLocation(bool value) {
    _expandZoomInOutLocation = value;
    notifyListeners();
  }

  bool get expandLayer => _expandLayer;
  set expandLayer(bool value) {
    _expandLayer = value;
    notifyListeners();
  }

  bool get expandSearchNavigation => _expandSearchNavigation;
  set expandSearchNavigation(bool value) {
    _expandSearchNavigation = value;
    notifyListeners();
  }

  bool get searchToggle => _searchToggle;
  set searchToggle(bool value) {
    _searchToggle = value;
    notifyListeners();
  }

  bool get getDirection => _getDirection;
  set getDirection(bool value) {
    _getDirection = value;
    notifyListeners();
  }

  bool get isNormal => _isNormal;
  set isNormal(bool value) {
    _isNormal = value;
    notifyListeners();
  }

  bool get isSatellite => _isSatellite;
  set isSatellite(bool value) {
    _isSatellite = value;
    notifyListeners();
  }

  bool get hasInternet => _hasInternet;
  set hasInternet(bool value) {
    _hasInternet = value;
    notifyListeners();
  }

  /// Methods
  clearSearchController() {
    searchController.clear();
    notifyListeners();
  }

  clearFromController() {
    fromController.clear();
    notifyListeners();
  }

  clearToController() {
    toController.clear();
    notifyListeners();
  }

  clearMarkers() {
    markers.clear();
    notifyListeners();
  }

  clearPolyline() {
    polylines.clear();
    notifyListeners();
  }

  void setPolyline() {
    final String polylineIdVal = 'polyline_$polylineIdCounter';

    polylineIdCounter += 1;
    notifyListeners();

    polylines.add(
      Polyline(
        polylineId: PolylineId(polylineIdVal),
        width: 5,
        color: ColorService.green,
        points: fromTo.map((e) => LatLng(e.first, e.last)).toList(),
      ),
    );
  }

  void _setMarker(point) {
    markerIdCounter += 1;
    notifyListeners();

    final Marker marker = Marker(
      markerId: MarkerId('marker_$markerIdCounter'),
      position: point,
      onTap: () {},
      icon: BitmapDescriptor.defaultMarker,
    );

    markers.add(marker);
    notifyListeners();
  }

  Future<void> gotoSearchedPlace({required LatLng position, double zoom = 13.0, bool putMarker = true}) async {
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: position,
          zoom: zoom,
        ),
      ),
    );

    if (putMarker) {
      _setMarker(position);
    }
  }

  Future<LatLng> getUserCurrentPosition() async {
    final position = await Permission.getGeoLocationPosition();
    debugPrint('\n\t User\'s location: (${position.latitude}, ${position.longitude})');
    return LatLng(position.latitude, position.longitude);
  }

  gotoPlace() {
    /*
    assert(southwest.latitude <= northeast.latitude);
    southwest.latitude <= northeast.latitude
    northeast.longitude <= southwest.longitude
     */
    // print('\n\n\t $fromTo');
    // print('* \t [${min(fromTo[0][0], fromTo[1][0])}, ${max(fromTo[0][1], fromTo[1][1])}]');
    // print('* \t [${max(fromTo[0][0], fromTo[1][0])}, ${min(fromTo[0][1], fromTo[1][1])}]');
    // _googleMapController.animateCamera(
    //
    //   CameraUpdate.newLatLngBounds(
    //     LatLngBounds(
    //       southwest: LatLng(min(fromTo[0][0], fromTo[1][0]), max(fromTo[0][1], fromTo[1][1]),),
    //       northeast: LatLng(max(fromTo[0][0], fromTo[1][0]), min(fromTo[0][1], fromTo[1][1]),),
    //     ),
    //     25,
    //   ),
    // );
    gotoSearchedPlace(position: LatLng(fromTo[0][0], fromTo[0][1]), zoom: 10, putMarker: false);
    _setMarker(LatLng(fromTo[0][0], fromTo[0][1]));
    _setMarker(LatLng(fromTo[1][0], fromTo[1][1]));
  }
}
