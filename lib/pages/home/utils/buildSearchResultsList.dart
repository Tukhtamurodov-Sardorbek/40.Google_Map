import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_map_integration/models/autocomplete_model.dart';
import 'package:google_map_integration/pages/home/provider.dart';
import 'package:google_map_integration/providers/search_autocomplete.dart';
import 'package:google_map_integration/services/map_services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class BuildSearchResultsList extends StatelessWidget {
  final AutoCompleteResult placeItem;
  final bool isFromTo;
  const BuildSearchResultsList({Key? key, required this.placeItem, required this.isFromTo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    final fromFlag = context.watch<FromToggle>();
    final toFlag = context.watch<ToToggle>();
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTapDown: (_) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onTap: () {
          if (isFromTo) {
            if (fromFlag.fromToggle) {
              fromFlag.toggleFrom();
              MapService()
                  .getPlace(
                placeItem.description ??
                    provider.searchController.text.trim().toString(),
                context,
              )
                  .then((location) {
                provider.fromTo[0] = [
                  location.first.latitude,
                  location.first.longitude
                ];
              });
            } else if (toFlag.toToggle) {
              toFlag.toggleTo();
              MapService()
                  .getPlace(
                placeItem.description ??
                    provider.searchController.text.trim().toString(),
                context,
              )
                  .then((location) {
                provider.fromTo[1] = [
                  location.first.latitude,
                  location.first.longitude
                ];
              });
            }
          } else {
            MapService()
                .getPlace(
              placeItem.description ??
                  provider.searchController.text.trim().toString(),
              context,
            )
                .then(
              (List<Location> place) {
                place.isNotEmpty
                    ? provider.gotoSearchedPlace(
                        position:
                            LatLng(place.first.latitude, place.first.longitude),
                      )
                    : null;
              },
            );
          }
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
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
