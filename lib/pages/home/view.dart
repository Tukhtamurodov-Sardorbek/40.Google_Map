import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_map_integration/models/autocomplete_model.dart';
import 'package:google_map_integration/pages/home/utils/buildSearchResultsList.dart';
import 'package:google_map_integration/providers/search_autocomplete.dart';
import 'package:google_map_integration/services/color_service.dart';
import 'package:google_map_integration/services/map_services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => HomeProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => PlaceResults(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => SearchToggle(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => FromToggle(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => ToToggle(),
        ),
      ],
      builder: (context, child) => _buildPage(context),
    );
  }

  Widget _buildPage(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    final allSearchResults = context.watch<PlaceResults>();
    final searchFlag = context.watch<SearchToggle>();
    final fromFlag = context.watch<FromToggle>();
    final toFlag = context.watch<ToToggle>();

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: provider.isNormal
                ? MapType.normal
                : provider.isSatellite
                ? MapType.satellite
                : MapType.terrain,
            markers: provider.markers,
            polylines: provider.polylines,
            initialCameraPosition: provider.cameraPosition,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: true,
            zoomControlsEnabled: false,
            compassEnabled: false,
            trafficEnabled: false,
            buildingsEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              provider.googleMapController = controller;
            },
            onTap: (coordinates) {
              // * To move the camera to the place where is tapped with animation
              provider.googleMapController.animateCamera(
                CameraUpdate.newLatLng(coordinates),
              );
            },
          ),
          Positioned(
            top: 360,
            right: 16,
            child: GestureDetector(
              onTap: () {
                provider.expandLayer = !provider.expandLayer;
              },
              child: AnimatedContainer(
                  height: provider.expandLayer ? 280 : 55,
                  width: provider.expandLayer ? 60 : 55,
                  duration: const Duration(milliseconds: 550),
                  curve: Curves.linearToEaseOut,
                  decoration: BoxDecoration(
                    borderRadius: provider.expandLayer
                        ? BorderRadius.circular(10)
                        : BorderRadius.circular(10),
                    color: ColorService.main.withOpacity(0.7),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            provider.expandLayer = !provider.expandLayer;
                          },
                          iconSize: 32,
                          color: ColorService.blue,
                          icon: const Icon(Icons.layers),
                        ),
                        provider.expandLayer
                            ? Expanded(
                          child: GestureDetector(
                              onTap: () {
                                provider.isNormal = true;
                                provider.isSatellite = false;
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Container(
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                      child: const Image(
                                        image: AssetImage(
                                          'assets/images/normal.jpg',
                                        ),
                                        fit: BoxFit.cover,
                                        height: 45,
                                        width: 45,
                                      ),
                                    ),
                                  ),
                                  const Flexible(
                                    fit: FlexFit.loose,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                        8.0,
                                        4.0,
                                        8.0,
                                        4.0,
                                      ),
                                      child: FittedBox(
                                        child: Text(
                                          'Default',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        )
                            : const SizedBox(),
                        provider.expandLayer
                            ? Expanded(
                          child: GestureDetector(
                              onTap: () {
                                provider.isNormal = false;
                                provider.isSatellite = true;
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Container(
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                      child: const Image(
                                        image: AssetImage(
                                          'assets/images/satellite.jpg',
                                        ),
                                        fit: BoxFit.cover,
                                        height: 45,
                                        width: 45,
                                      ),
                                    ),
                                  ),
                                  const Flexible(
                                    fit: FlexFit.loose,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                        8.0,
                                        4.0,
                                        8.0,
                                        4.0,
                                      ),
                                      child: FittedBox(
                                        child: Text(
                                          'Satellite',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        )
                            : const SizedBox(),
                        provider.expandLayer
                            ? Expanded(
                          child: GestureDetector(
                              onTap: () {
                                provider.isNormal = false;
                                provider.isSatellite = false;
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Container(
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                      child: const Image(
                                        image: AssetImage(
                                          'assets/images/normal.jpg',
                                        ),
                                        fit: BoxFit.cover,
                                        height: 45,
                                        width: 45,
                                      ),
                                    ),
                                  ),
                                  const Flexible(
                                    fit: FlexFit.loose,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                        8.0,
                                        4.0,
                                        8.0,
                                        4.0,
                                      ),
                                      child: FittedBox(
                                        child: Text(
                                          'Terrain',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        )
                            : const SizedBox(),
                      ],
                    ),
                  )),
            ),
          ),
          provider.searchToggle
              ? Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.fromLTRB(15.0, 40.0, 15.0, 5.0),
            child: TextFormField(
              controller: provider.searchController,
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
                      provider.searchToggle = false;
                      provider.clearSearchController();
                      provider.markers.clear();
                      if (searchFlag.searchToggle) {
                        searchFlag.toggleSearch();
                      }
                    },
                    icon: const Icon(
                      Icons.close,
                      color: ColorService.red,
                    ),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                      const BorderSide(color: Colors.transparent)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                      const BorderSide(color: Colors.transparent)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                      const BorderSide(color: Colors.transparent))),
              onChanged: (value) {
                if (provider.debounce?.isActive ?? false) {
                  provider.debounce?.cancel();
                }
                provider.debounce =
                    Timer(const Duration(milliseconds: 700), () async {
                      if (value.length > 2) {
                        if (!searchFlag.searchToggle) {
                          searchFlag.toggleSearch();
                          provider.clearMarkers();
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
                physics: const BouncingScrollPhysics(),
                itemCount:
                allSearchResults.allReturnedResults.length,
                itemBuilder: (BuildContext context, int index) {
                  return BuildSearchResultsList(
                    placeItem: allSearchResults.allReturnedResults[index],
                    isFromTo: false,
                  );
                },
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
                        if (searchFlag.searchToggle) {
                          searchFlag.toggleSearch();
                        }
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
          provider.getDirection
              ? Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 40.0, 15.0, 5.0),
            child: Column(
              children: [
                TextFormField(
                  controller: provider.fromController,
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
                    hintText: 'From',
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(
                      CupertinoIcons.location,
                      color: ColorService.blue,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                        const BorderSide(color: Colors.transparent)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                        const BorderSide(color: Colors.transparent)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    Timer(
                      const Duration(milliseconds: 700),
                          () async {
                        if (value.length > 2) {
                          if (!fromFlag.fromToggle) {
                            fromFlag.toggleFrom();
                            provider.clearMarkers();
                          }

                          List<AutoCompleteResult> searchResults =
                          await MapService().searchPlaces(value);

                          allSearchResults.setResults(searchResults);
                        } else {
                          List<AutoCompleteResult> emptyList = [];
                          allSearchResults.setResults(emptyList);
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 4.0),
                TextFormField(
                  controller: provider.toController,
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
                    hintText: 'To',
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(
                      CupertinoIcons.location,
                      color: ColorService.blue,
                    ),
                    suffixIcon: SizedBox(
                      width: 96.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              print(provider.fromTo);
                              provider.clearMarkers();
                              provider.clearPolyline();
                              provider.gotoPlace();
                              provider.setPolyline();
                            },
                            icon: const Icon(
                              Icons.search,
                              color: ColorService.red,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              provider.getDirection = false;
                              provider.clearMarkers();
                              provider.clearPolyline();
                              provider.clearFromController();
                              provider.clearToController();
                            },
                            icon: const Icon(
                              Icons.close,
                              color: ColorService.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                        const BorderSide(color: Colors.transparent)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                        const BorderSide(color: Colors.transparent)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    Timer(
                      const Duration(milliseconds: 700),
                          () async {
                        if (value.length > 2) {
                          if (!toFlag.toToggle) {
                            toFlag.toggleTo();
                            provider.clearMarkers();
                          }

                          List<AutoCompleteResult> searchResults =
                          await MapService().searchPlaces(value);

                          allSearchResults.setResults(searchResults);
                        } else {
                          List<AutoCompleteResult> emptyList = [];
                          allSearchResults.setResults(emptyList);
                        }
                      },
                    );
                  },
                ),
                fromFlag.fromToggle || toFlag.toToggle
                    ? Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width - 30,
                  margin: const EdgeInsets.only(top: 4.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: ColorService.main.withOpacity(0.8),
                  ),
                  child: allSearchResults
                      .allReturnedResults.isNotEmpty
                      ? ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: const BouncingScrollPhysics(),
                    itemCount: allSearchResults
                        .allReturnedResults.length,
                    itemBuilder:
                        (BuildContext context, int index) {
                      return BuildSearchResultsList(
                        placeItem: allSearchResults.allReturnedResults[index],
                        isFromTo: true,
                      );
                    },
                  )
                      : Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    crossAxisAlignment:
                    CrossAxisAlignment.center,
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
                )
                    : const SizedBox(),
              ],
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
            AnimatedContainer(
              height: 60,
              width: provider.expandSearchNavigation ? 200 : 60,
              duration: const Duration(milliseconds: 550),
              curve: Curves.linear,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: ColorService.main,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 60,
                    width: 50,
                    padding: const EdgeInsets.only(left: 10.0),
                    child: AnimatedRotation(
                      duration: const Duration(milliseconds: 550),
                      turns: provider.expandSearchNavigation ? 0.5 : 1,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          provider.expandZoomInOutLocation = false;
                          provider.expandSearchNavigation = !provider.expandSearchNavigation;
                        },
                        iconSize: 33,
                        color: ColorService.blue,
                        icon: const Icon(Icons.double_arrow),
                      ),
                    ),
                  ),
                  provider.expandSearchNavigation
                      ? Flexible(
                    fit: FlexFit.tight,
                    child: GestureDetector(
                      onTap: () {
                        provider.searchToggle = true;
                        provider.getDirection = false;

                      },
                      child: const Icon(
                        Icons.search,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                  )
                      : const SizedBox(),
                  provider.expandSearchNavigation
                      ? Flexible(
                    fit: FlexFit.tight,
                    child: GestureDetector(
                      onTap: () {
                        provider.searchToggle = false;
                        provider.getDirection = true;
                      },
                      child: const Icon(
                        Icons.navigation_outlined,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                  )
                      : const SizedBox(),
                  provider.expandSearchNavigation ? const SizedBox(width: 8.0) : const SizedBox(),
                ],
              ),
            ),
            AnimatedContainer(
                height: 60,
                width: provider.expandZoomInOutLocation ? 260 : 60,
                duration: const Duration(milliseconds: 550),
                curve: Curves.linear,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: ColorService.main,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    provider.expandZoomInOutLocation
                        ? Flexible(
                      fit: FlexFit.tight,
                      child: IconButton(
                        onPressed: () {
                          provider.expandZoomInOutLocation = !provider.expandZoomInOutLocation;
                        },
                        iconSize: 33,
                        color: ColorService.blue,
                        icon: const Icon(Icons.double_arrow),
                      ),
                    )
                        : const SizedBox(),
                    provider.expandZoomInOutLocation
                        ? Flexible(
                      fit: FlexFit.tight,
                      child: GestureDetector(
                        onTap: () {
                          provider.googleMapController
                              .animateCamera(CameraUpdate.zoomOut());
                        },
                        child: const Icon(
                          Icons.zoom_out,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                    )
                        : const SizedBox(),
                    provider.expandZoomInOutLocation
                        ? Flexible(
                      fit: FlexFit.tight,
                      child: IconButton(
                        onPressed: () async {
                          LatLng position =
                          await provider.getUserCurrentPosition();
                          provider.gotoSearchedPlace(
                              position: position,
                              zoom: 16,
                              putMarker: false);
                        },
                        icon: const Icon(
                          Icons.my_location_outlined,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                    )
                        : const SizedBox(),
                    provider.expandZoomInOutLocation
                        ? Flexible(
                      fit: FlexFit.tight,
                      child: GestureDetector(
                        onTap: () {
                          provider.googleMapController.animateCamera(
                            CameraUpdate.zoomIn(),
                          );
                        },
                        child: const Icon(
                          Icons.zoom_in,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                    )
                        : const SizedBox(),
                    provider.expandZoomInOutLocation ? const SizedBox(width: 8.0) : const SizedBox(),
                    provider.expandZoomInOutLocation
                        ? const SizedBox()
                        : SizedBox(
                      height: 60,
                      width: 60,
                      child: IconButton(
                        onPressed: () {
                          provider.expandSearchNavigation = false;
                          provider.expandZoomInOutLocation = !provider.expandZoomInOutLocation;
                        },
                        iconSize: 33,
                        color: ColorService.blue,
                        icon: const Icon(Icons.menu),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

