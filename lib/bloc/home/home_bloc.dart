import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../model/trip.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeLoading()) {
    on<HomeLoadEvent>((event, emit) async{
        emit(HomeLoading());
        await FirebaseFirestore.instance
          .collection('Trip')
          .get()
          .then((value) {
            List<Trip> trips = [];
            trips = value.docs.map((e) => Trip.fromJson(e.data())).toList();

            emit(HomeLoaded(trips: trips));
      });
    });
  }
}
