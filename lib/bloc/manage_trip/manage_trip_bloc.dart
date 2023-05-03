import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_together/model/trip.dart';
import 'package:logger/logger.dart';

part 'manage_trip_event.dart';
part 'manage_trip_state.dart';

class ManageTripBloc extends Bloc<ManageTripEvent, ManageTripState> {
  ManageTripBloc() : super(ManageTripLoading()) {
    on<ManageTripLoadEvent>(_loadTrips);
    on<ManageTripUpdateEvent>(_update);
  }

  _loadTrips(ManageTripLoadEvent event, Emitter<ManageTripState> emit) async {
    Logger().v(FirebaseAuth.instance.currentUser!.uid);
    List<Trip> trips = [];
    loadMyOrder().listen((event) => add(ManageTripUpdateEvent(trips: event)));
  }

  Stream<List<Trip>> loadMyOrder() {
    return FirebaseFirestore.instance
        .collection('Trip')
        .where('membersId',
            arrayContains: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((event) {
      return event.docs.map((e) => Trip.fromJson(e.data())).toList();
    });
  }

  _update(ManageTripUpdateEvent event, Emitter<ManageTripState> emit) {
    emit(ManageTripLoaded(trips: event.trips));
  }
}
