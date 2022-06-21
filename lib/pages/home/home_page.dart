import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_map_integration/models/autocomplete_model.dart';
import 'package:google_map_integration/providers/search_autocomplete.dart';
import 'package:google_map_integration/services/color_service.dart';
import 'package:google_map_integration/services/map_services.dart';
import 'package:google_map_integration/services/permission_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  // * Initial camera position
  final _cameraPosition = const CameraPosition(
    target: LatLng(41.3123363, 69.2787079),
    zoom: 14.4746,
  );
  // * To move the camera to the place where is tapped with animation
  late GoogleMapController _googleMapController;
  // * Debounce to throttle async calls during search
  Timer? _debounce;
  // * Markers
  Set<Marker> _markers = {};
  int markerIdCounter = 1;
  bool searchToggle = false;
  bool radiusSlider = false;
  bool pressedNear = false;
  bool cardTapped = false;
  bool getDirection = false;
  bool isExpanded = false;
  final TextEditingController _textEditingController = TextEditingController();

  void _setMarker(point) {
    var counter = markerIdCounter++;

    final Marker marker = Marker(
        markerId: MarkerId('marker_$counter'),
        position: point,
        onTap: () {},
        icon: BitmapDescriptor.defaultMarker);

    setState(() {
      _markers.add(marker);
    });
  }

  Future<void> gotoSearchedPlace(double lat, double lng) async {
    _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 13)));

    _setMarker(LatLng(lat, lng));
  }

  Future<LatLng> _getUserCurrentPosition() async {
    final position = await Permission.getGeoLocationPosition();
    return LatLng(position.latitude, position.longitude);
  }

  @override
  Widget build(BuildContext context) {
    final allSearchResults = ref.watch(placeResultsProvider);
    final searchFlag = ref.watch(searchToggleProvider);

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            markers: _markers,
            initialCameraPosition: _cameraPosition,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: true,
            zoomControlsEnabled: false,
            compassEnabled: false,
            buildingsEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _googleMapController = controller;
            },
            onTap: (coordinates) {
              // * To move the camera to the place where is tapped with animation
              _googleMapController.animateCamera(
                CameraUpdate.newLatLng(coordinates),
              );
            },
          ),
          searchToggle
              ? Container(
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.fromLTRB(15.0, 40.0, 15.0, 5.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _textEditingController,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: ColorService.main,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 15.0,
                            ),
                            hintText: 'Search',
                            hintStyle: const TextStyle(color: Colors.grey),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: ColorService.blue,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  searchToggle = false;
                                  _textEditingController.clear();
                                  _markers.clear();
                                  if (searchFlag.searchToggle) {
                                    searchFlag.toggleSearch();
                                  }
                                });
                              },
                              icon: const Icon(
                                Icons.close,
                                color: ColorService.red,
                              ),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: Colors.transparent)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: Colors.transparent)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: Colors.transparent))),
                        onChanged: (value) {
                          if (_debounce?.isActive ?? false) {
                            _debounce?.cancel();
                          }
                          _debounce = Timer(const Duration(milliseconds: 700),
                              () async {
                            if (value.length > 2) {
                              if (!searchFlag.searchToggle) {
                                searchFlag.toggleSearch();
                                _markers = {};
                              }

                              List<AutoCompleteResult> searchResults =
                                  await MapService().searchPlaces(value);

                              allSearchResults.setResults(searchResults);
                            } else {
                              List<AutoCompleteResult> emptyList = [];
                              allSearchResults.setResults(emptyList);
                            }
                          });
                        },
                      )
                    ],
                  ),
                )
              : const SizedBox(),
          searchFlag.searchToggle
              ? Positioned(
                  top: 100.0,
                  left: 15.0,
                  child: Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width - 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: ColorService.main.withOpacity(0.8),
                      // Colors.white.withOpacity(0.7),
                    ),
                    child: allSearchResults.allReturnedResults.isNotEmpty
                        ? ListView.builder(
                            itemCount:
                                allSearchResults.allReturnedResults.length,
                            itemBuilder: (BuildContext context, int index) {
                              return buildResultsList(
                                allSearchResults.allReturnedResults[index],
                                searchFlag,
                              );
                            },
                            // children: [
                            //   ...allSearchResults.allReturnedResults.map(
                            //     (e) => buildResultsList(e, searchFlag),
                            //   ),
                            // ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'No result',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'WorkSans',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              SizedBox(
                                width: 125.0,
                                child: ElevatedButton(
                                  onPressed: () {
                                    searchFlag.toggleSearch();
                                  },
                                  child: const Center(
                                    child: Text(
                                      'Close',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'WorkSans',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(left: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  searchToggle = true;
                  radiusSlider = false;
                  pressedNear = false;
                  cardTapped = false;
                  getDirection = false;
                });
              },
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: ColorService.main,
                ),
                child: const Icon(
                  Icons.search,
                  size: 32,
                  color: ColorService.blue,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                isExpanded = !isExpanded;
                setState(() {});
              },
              child: AnimatedContainer(
                height: 60,
                width: isExpanded ? 260 : 60,
                duration: const Duration(milliseconds: 550),
                curve: Curves.linear,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: ColorService.main,
                ),
                child: isExpanded
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            child: IconButton(
                              onPressed: () {
                                isExpanded = !isExpanded;
                                setState(() {});
                              },
                              iconSize: 32,
                              color: ColorService.blue,
                              icon: const Icon(Icons.double_arrow),
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.tight,
                            child: GestureDetector(
                              onTap: () {
                                _googleMapController
                                    .animateCamera(CameraUpdate.zoomOut());
                              },
                              child: const Icon(
                                Icons.zoom_out,
                                size: 32,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.tight,
                            child: GestureDetector(
                              onTap: () async {
                                _googleMapController.animateCamera(
                                  CameraUpdate.newCameraPosition(
                                    CameraPosition(
                                      target: await _getUserCurrentPosition(),
                                      zoom: 16,
                                    ),
                                  ),
                                );
                              },
                              child: const Icon(
                                Icons.my_location_outlined,
                                size: 32,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.tight,
                            child: GestureDetector(
                              onTap: () {
                                _googleMapController.animateCamera(
                                  CameraUpdate.zoomIn(),
                                );
                              },
                              child: const Icon(
                                Icons.zoom_in,
                                size: 32,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                        ],
                      )
                    : const Icon(
                        Icons.menu,
                        size: 32,
                        color: ColorService.blue,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // FabCircularMenu(
  //   alignment: Alignment.bottomLeft,
  //   fabColor: Colors.blue.shade50,
  //   fabOpenColor: Colors.red.shade100,
  //   ringDiameter: 180,
  //   ringWidth: 60,
  //   ringColor: Colors.blueGrey,
  //   children: [
  //     IconButton(
  //       splashRadius: 1,
  //       onPressed: () {
  //         setState(() {
  //           searchToggle = true;
  //           radiusSlider = false;
  //           pressedNear = false;
  //           cardTapped = false;
  //           getDirection = false;
  //         });
  //       },
  //       icon: const Icon(Icons.search),
  //     ),
  //     IconButton(
  //       splashRadius: 1,
  //       onPressed: () {
  //         setState(() {});
  //       },
  //       icon: const Icon(Icons.navigation_outlined),
  //     ),
  //   ],
  // ),
  Widget buildResultsList(
      AutoCompleteResult placeItem, SearchToggle searchFlag) {
    final allSearchResults = ref.watch(placeResultsProvider);
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTapDown: (_) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onTap: () {
          print('\n###############################################');
          print('${placeItem.description} is tapped');
          print('###############################################\n');
          MapService()
              .getPlace(
                  placeItem.description ??
                      _textEditingController.text.trim().toString(),
                  context)
              .then((List<Location> place) {
            place.isNotEmpty
                ? gotoSearchedPlace(place.first.latitude, place.first.longitude)
                : null;
          });
          // gotoSearchedPlace(place[0].latitude, place[0].longitude);
          // await locationFromAddress(placeItem.description ??
          //     _textEditingController.text.trim().toString()).then((List<Location> locations) {
          //       print('Lat: ${locations.first.latitude}; Long: ${locations.first.longitude}');
          // });

          // var place = await MapService().getPlace(placeItem.placeId, context);
          // gotoSearchedPlace(place['geometry']['location']['lat'],
          //     place['geometry']['location']['lng']);
          // gotoSearchedPlace(place.first.latitude, place.first.longitude);
          // searchFlag.toggleSearch();
          // searchResults[index].description ??
          //     _textEditingController.text.trim().toString();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, color: Colors.green, size: 25.0),
            const SizedBox(width: 4.0),
            SizedBox(
              height: 40.0,
              width: MediaQuery.of(context).size.width - 75.0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  placeItem.description ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
