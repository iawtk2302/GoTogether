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
  }

  _loadTrips(ManageTripLoadEvent event, Emitter<ManageTripState> emit) async {
    Logger().v(FirebaseAuth.instance.currentUser!.uid);
    List<Trip> trips = [];
    final snapshot = await FirebaseFirestore.instance
        .collection('Trip')
        .where('membersId',
            arrayContains: FirebaseAuth.instance.currentUser!.uid)
        .get();
    // print('Query: ${snapshot.qu.toString()}');
    trips = snapshot.docs.map((e) => Trip.fromJson(e.data())).toList();

    emit(ManageTripLoaded(trips: trips));
  }
}
