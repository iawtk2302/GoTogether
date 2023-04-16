import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';

import '../../model/trip.dart';

part 'map_support_event.dart';
part 'map_support_state.dart';

class MapSupportBloc extends Bloc<MapSupportEvent, MapSupportState> {
  MapSupportBloc() : super(MapSupportInitial()) {
    on<MapSupportLoadMembersEvent>(_loadMember);
    on<MapSupportUpdateMembersEvent>(_updateMember);
    on<MapSupportUpdatePositionToFirebase>(_updatePosition);
  }

  _loadMember(
      MapSupportLoadMembersEvent event, Emitter<MapSupportState> emit) async {
    final tripStream = FirebaseFirestore.instance
        .collection('Trip')
        .doc(event.idTrip)
        .snapshots();
    Trip? trip;
    tripStream.listen((event) {
      trip = Trip.fromJson(event.data()!);
      Logger().i(trip);
      if (trip == null) {
        return;
      } else {
        add(MapSupportUpdateMembersEvent(members: trip!.members));
      }
    });
    if (trip != null) {
      emit(MapSupportLoaded(members: trip!.members));
    } else {
      emit(const MapSupportLoaded(members: []));
    }
  }

  _updateMember(
      MapSupportUpdateMembersEvent event, Emitter<MapSupportState> emit) {
    if (state is MapSupportLoaded) {
      // final currentState = state as MapSupportLoaded;

      emit(MapSupportLoaded(members: event.members));
    }
  }

  _updatePosition(MapSupportUpdatePositionToFirebase event,
      Emitter<MapSupportState> emit) async {
    final data = await FirebaseFirestore.instance
        .collection('Trip')
        .doc(event.idTrip)
        .get();

    Trip trip = Trip.fromJson(data.data()!);

    Member member = trip.members
        .where((element) => element.idUser == "aaaa")
        .first
        .copyWith(
            lat: event.latLng.latitude.toString(),
            lng: event.latLng.longitude.toString());

    // Logger().v(member);

    trip.members.removeWhere((element) => element.idUser == 'aaaa');

    Logger().i(trip.members);

    trip.members.add(member);

    Logger().d(trip.members);

    await FirebaseFirestore.instance
        .collection('Trip')
        .doc(event.idTrip)
        .update({
      "members": [...trip.members.map((e) => e.toJson()).toList()]
    });

    // Trip newTrip = trip.copyWith(members: trip.members);
    // Logger().v(tripStream.data());

    // .update({"lat": event.latLng.latitude, "lng": event.latLng.longitude});
  }
}
