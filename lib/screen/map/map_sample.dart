import 'dart:async';
import 'dart:typed_data';
import 'dart:math' show cos, sqrt, asin;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
// import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_together/bloc/map_support/map_support_bloc.dart';
import 'package:go_together/model/trip.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_routes/google_maps_routes.dart';
import 'package:logger/logger.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';

import '../../utils/map_utils.dart';
import 'categories_places.dart';

class MapSuport extends StatefulWidget {
  const MapSuport({Key? key, required this.icon, required this.trip})
      : super(key: key);
  final BitmapDescriptor icon;
  final Trip trip;
  @override
  State<MapSuport> createState() => MapSuportState();
}

class MapSuportState extends State<MapSuport> {
  final Completer<GoogleMapController> _controller = Completer();

  StreamSubscription<Position>? positionStream;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(10.874327, 106.7992051),
    zoom: 14.4746,
  );

  @override
  void initState() {
    _goToGPS();
    super.initState();
  }

  @override
  void dispose() {
    if (positionStream != null) {
      positionStream?.cancel();
    }
    super.dispose();
  }

  // list of locations to display polylines
  List<LatLng> latLen = [
    // LatLng(10.8695733, 106.8427823),
    // LatLng(10.8895733, 106.8047823),
  ];

  Set<Marker> markers = {};
  int markerId = 1;

  MapsRoutes route = MapsRoutes();
  DistanceCalculator distanceCalculator = DistanceCalculator();
  String totalDistance = 'No route';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: Stack(
        children: [
          BlocConsumer<MapSupportBloc, MapSupportState>(
            listener: (context, state) {
              if (state is MapSupportLoaded) {
                for (var element in state.members) {
                  if (markers.any((marker) =>
                      marker.markerId == MarkerId(element.idUser))) {
                    markers.removeWhere((marker) =>
                        marker.markerId == MarkerId(element.idUser));
                  }
                  markers.add(Marker(
                    markerId: MarkerId((element.idUser).toString()),
                    position: LatLng(
                        double.parse(element.lat), double.parse(element.lng)),
                    icon: state.icons![element.idUser]!,
                  ));
                }
              }
            },
            builder: (context, state) {
              if (state is MapSupportInitial) {
                return const SizedBox();
              } else if (state is MapSupportLoaded) {
                return _buildMap();
              } else {
                return const SizedBox();
              }
            },
          ),
          Positioned(
              top: 6,
              left: 0,
              right: 0,
              child: CategoriesPlaces(
                onPress: (place) async {
                  await _suggestPlaces(place);
                },
              )),
          Positioned(
              bottom: 120,
              // left: 0,
              right: 5,
              child: _buildGotoGPS()),
          Positioned(bottom: 20, left: 0, right: 0, child: _buildDirection())
        ],
      ),
    );
  }

  Future<void> _suggestPlaces(place) async {
    List<Marker>? newMarkers = await MapUtils.getPlaces(place);

    markers.removeWhere(
      (element) =>
          element.markerId != MarkerId('gps') &&
          element.markerId != MarkerId('1'),
    );

    Logger().w(newMarkers);

    if (newMarkers != null && newMarkers.isNotEmpty) {
      for (var e in newMarkers) {
        setState(() {
          markers.add(e);
        });
      }
    }
  }

  AppBar _buildAppbar() {
    return AppBar(actions: [
      IconButton(
        icon: Icon(Icons.search),
        onPressed: () async {
          openSearch([]);
        },
      )
    ]);
  }

  Wrap _buildDirection() {
    return Wrap(alignment: WrapAlignment.center, children: [
      Material(
        borderRadius: BorderRadius.circular(25),
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.blue,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.directions,
              color: Colors.white,
            ),
            onPressed: () async {
              await _direction();
            },
          ),
        ),
      ),
    ]);
  }

  Container _buildGotoGPS() {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
      ),
      child: IconButton(
        icon: Icon(Icons.gps_fixed),
        onPressed: () {
          _goToGPS();
        },
      ),
    );
  }

  GoogleMap _buildMap() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _kGooglePlex,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      onTap: (argument) {
        route.routes.clear();
        Logger().v('${argument.latitude}/${argument.longitude}');
        if (markers.length != 1 && markers.isNotEmpty) {
          if (markers.any((element) => element.markerId == MarkerId('1'))) {
            int index = markers.toList().indexOf(markers
                .where((element) => element.markerId == MarkerId('1'))
                .first);
            markers.remove(markers
                .where((element) => element.markerId == MarkerId('1'))
                .first);
            latLen.removeAt(index);
          }
        }
        setState(() {
          markers.add(
            Marker(
              markerId: MarkerId((markerId).toString()),
              position: LatLng(argument.latitude, argument.longitude),
              icon: widget.icon,
            ),
          );
        });
        if (markers.length > 1) {
          latLen.add(LatLng(argument.latitude, argument.longitude));
        }
      },
      markers: markers,
      polylines: route.routes,
    );
  }

  Future<void> _goToGPS() async {
    final GoogleMapController controller = await _controller.future;
    Position position = await MapUtils.determinePosition();
    // setState(() {
    //   LatLng latLng = LatLng(position.latitude, position.longitude);
    // });

    setState(() {
      markers.add(
        Marker(
          markerId: MarkerId('gps'),
          position: LatLng(position.latitude, position.longitude),
          icon: widget.icon,
        ),
      );
      latLen.add(LatLng(position.latitude, position.longitude));
    });
    positionStream = Geolocator.getPositionStream().listen(
      (event) {
        // Logger().v(event.latitude);
        if (markers.any((element) => element.markerId == MarkerId('gps'))) {
          latLen.removeWhere((element) =>
              markers
                  .firstWhere((element) => element.markerId == MarkerId('gps'))
                  .position ==
              element);
          int index = markers.toList().indexOf(markers
              .where((element) => element.markerId == MarkerId('gps'))
              .first);
          markers.remove(markers
              .where((element) => element.markerId == MarkerId('gps'))
              .first);
        }

        markers.add(
          Marker(
            markerId: MarkerId('gps'),
            position: LatLng(position.latitude, position.longitude),
            icon: widget.icon,
          ),
        );
        latLen.add(LatLng(position.latitude, position.longitude));
        BlocProvider.of<MapSupportBloc>(context).add(
            MapSupportUpdatePositionToFirebase(
                latLng: LatLng(position.latitude, position.longitude),
                idTrip: widget.trip.idTrip));
      },
    );

    Logger().v('${position.latitude}/${position.longitude}');
    CameraPosition yourPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 16);

    controller.animateCamera(CameraUpdate.newCameraPosition(yourPosition));
  }

  openSearch(List<String> list) async {
    if (latLen.length < 2) {
      return;
    }
    double distance = MapUtils.calculateDistance(latLen[0].latitude,
        latLen[0].longitude, latLen[1].latitude, latLen[1].longitude);

    Logger().wtf(distance);
  }

  // void openSearch(List<String> types) async {
  //   Prediction? p = await PlacesAutocomplete.show(
  //       context: context,
  //       types: [],
  //       strictbounds: false,
  //       apiKey: 'AIzaSyDvpzD1mTGe2rRG5ddVYUZt3BmJRnbq5HU',
  //       mode: Mode.overlay, // Mode.fullscreen
  //       language: "vn",
  //       onError: (value) => print(value.status),
  //       components: [Component(Component.country, 'vn')]);

  //   await displayPrediction(p!);
  // }

  Future<void> displayPrediction(Prediction? p) async {
    if (p != null) {
      // get detail (lat/lng)
      GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: 'AIzaSyDvpzD1mTGe2rRG5ddVYUZt3BmJRnbq5HU',
        apiHeaders: await GoogleApiHeaders().getHeaders(),
      );
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId!);
      final lat = detail.result.geometry?.location.lat;
      final lng = detail.result.geometry?.location.lng;

      setState(() {
        markers.add(
          Marker(
            markerId: MarkerId((markerId).toString()),
            position: LatLng(lat!, lng!),
            icon: widget.icon,
          ),
        );
      });

      Logger().w("${p.description} - $lat/$lng");
      latLen.add(LatLng(lat!, lng!));
    }
  }

  Future<void> _direction() async {
    if (latLen.length < 2) {
      Logger().w('Need 2 coordinate/length: ${latLen.length}');
      return;
    }

    await route.drawRoute(latLen, 'Test routes', Color.fromRGBO(234, 51, 18, 1),
        'AIzaSyDvpzD1mTGe2rRG5ddVYUZt3BmJRnbq5HU',
        travelMode: TravelModes.driving);
    setState(() {
      totalDistance =
          distanceCalculator.calculateRouteDistance(latLen, decimals: 8);
    });
    Logger().v(totalDistance);
  }
}
