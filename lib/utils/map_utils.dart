import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';

import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

class MapUtils {
  static double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  static Future<List<Marker>?> getPlaces(String place) async {
    Logger().e('message');
    // Logger().e(markers);
    final places =
        GoogleMapsPlaces(apiKey: 'AIzaSyA09eMUuqRfjv3n269vbf-_FN5qKOUzRZ4');

    PlacesSearchResponse _response = await places.searchNearbyWithRadius(
        Location(lat: 10.8850279, lng: 106.7828548), 1500,
        type: place);

    final List<Marker> list = [];
    for (var e in _response.results) {
      e.photos.forEach((element) {
        Logger().v(element.photoReference);
       });

      list.add(Marker(
        markerId: MarkerId(UniqueKey().toString()),
        position: LatLng(e.geometry!.location.lat, e.geometry!.location.lng),
        // icon: BitmapDescriptor.defaultMarker,
      ));
    }
    return list;
  }

  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
  
}
